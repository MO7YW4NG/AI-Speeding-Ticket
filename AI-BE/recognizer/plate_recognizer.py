from pydantic_ai import Agent,RunContext
# from pydantic_ai.models.gemini import GeminiModel
from pydantic_ai.models.groq import GroqModel
from pydantic_ai.models.openai import OpenAIModel
from pydantic import BaseModel
from dotenv import load_dotenv
from dataclasses import dataclass
import os
import cv2
import numpy as np
import tempfile
import google.generativeai as genai
from google.api_core.exceptions import InvalidArgument 
# from openai import AsyncOpenAI
from groq import Groq, RateLimitError
# import ollama
import json
import base64
import asyncio

load_dotenv()
# model = GeminiModel('gemini-1.5-flash', api_key=os.environ['GEMINI_API_KEY'])
model = GroqModel('llama3-groq-70b-8192-tool-use-preview', api_key=os.environ['GROQ_API_KEY'])
genai.configure(api_key=os.environ['GEMINI_API_KEY'])
# openai = AsyncOpenAI(api_key=os.environ['OPENAI_API_KEY'])
# client = ollama.AsyncClient(host='http://localhost:11434')
client = Groq(api_key=os.environ['GROQ_API_KEY'])

@dataclass
class Deps:
    image_path: str

@dataclass
class LicensePlate(BaseModel):
    number: str

class BoundingBox(BaseModel):
    coordinates: list[float]
    
plateExtractor = Agent(model, system_prompt='Extract the exact image of plate from given image', result_type=Deps, retries=0)
plateRecognizer = Agent(model, system_prompt='Recognize the plate number from given image', result_type=LicensePlate, retries=1)

# Load the image once and reuse it
def load_image(image_path):
    return cv2.imread(image_path, cv2.IMREAD_COLOR)

# Function to encode the image
def encode_image(image):
    _, buffer = cv2.imencode('.jpg', image)
    return base64.b64encode(buffer).decode('utf-8')

def normalize_number(plate_number: str) -> str:
    """
    Normalize the license plate number based on predefined patterns.
    """
    plate_number = (
        str(plate_number.encode('utf-8').decode('utf-8'))
        .upper()
        .replace(" ", "")
        .replace("-", "")
        .replace("_", "")
        .replace('.', "")
        .replace(':', "")
    )

    return plate_number

@plateExtractor.tool
async def extract_plate_loc(ctx: RunContext[Deps]) -> list[float]:
    """
    Extract the bounding coordinates of the most prominent license plate from the provided image.

    Args:
        ctx (RunContext[Deps]): The context containing dependencies, including the image path.

    Returns:
        list[float]: A list of four floats representing the bounding box coordinates 
                     in the format [ymin, xmin, ymax, xmax].

    Raises:
        InvalidArgument: If the provided image data is invalid or cannot be processed.
    """
    image = load_image(ctx.deps.image_path)
    data = encode_image(image)
    # response = client.chat.completions.create(
    #     model="llama-3.2-90b-vision-preview",
    #     messages=[
    #         {
    #             "role": "user",
    #             "content": [
    #                 {"type": "text", "text": f"Detect most prominent license plate, return bounding box coordinates for the plate, must include the whole plate area (bottom-left and upper-right corners), in JSON format [ymin, xmin, ymax, xmax], for example: [100, 50, 216, 66]. The JSON object must use the schema: {{\"coordinates\": [ymin, xmin, ymax, xmax]}}"},
    #                 {
    #                     "type": "image_url",
    #                     "image_url": {
    #                         "url": f"data:image/jpeg;base64,{encode_image(ctx.deps.image_path)}"
    #                     }
    #                 },
    #             ],
    #         }
    #     ],
    #     temperature=0,
    #     response_format={"type": "json_object"},
    # )
    # result = response.choices[0].message.content

    model = genai.GenerativeModel("gemini-1.5-flash",
                                    generation_config=genai.GenerationConfig(
                                        response_mime_type="application/json",
                                        response_schema=list[int]
                                    )
                                )
    prompt = 'Return bounding boxes for the most prominent license plate in given image, the plate will be in the center of the image, must include the whole plate, in JSON format [ymin, xmin, ymax, xmax], for example: [100, 50, 216, 66]'
    try:
        response = model.generate_content(
            [
                {'mime_type':'image/jpeg', 'data': data}, 
                prompt
            ]
        )
    except InvalidArgument as e:
        file = genai.upload_file(ctx.deps.image_path)
        response = model.generate_content(
            [
                prompt,
                file
            ]
        )
        genai.delete_file(file)
    result = response.text
    print(response)
    return json.loads(result)
 
@plateExtractor.tool
async def crop_image(ctx: RunContext[Deps], plate_coordinates: list[float]) -> str:
    """
    Crop the license plate area from the image based on the provided bounding coordinates.

    Args:
        ctx (RunContext[Deps]): The context containing dependencies, including the image path.
        plate_coordinates (list[float]): A list of four floats representing the bounding box 
                                         coordinates [ymin, xmin, ymax, xmax].

    Returns:
        str: The file path to the cropped image.

    Raises:
        FileNotFoundError: If the original image file does not exist.
        ValueError: If the bounding coordinates are invalid.
    """
    img = load_image(ctx.deps.image_path)

    if plate_coordinates[0] <= 1:
        plate_coordinates = [coord * 1000 for coord in plate_coordinates]

    height, width, _ = img.shape
    abs_x1 = max(int(plate_coordinates[1] / 1000 * width) - 3, 0)
    abs_y1 = max(int(plate_coordinates[0] / 1000 * height) - 3, 0)
    abs_x2 = min(int(plate_coordinates[3] / 1000 * width) + 3, width)
    abs_y2 = min(int(plate_coordinates[2] / 1000 * height) + 3, height)

    cropped_img = img[abs_y1:abs_y2, abs_x1:abs_x2]
    
    cropped_img = cv2.cvtColor(cropped_img, cv2.COLOR_BGR2GRAY)
    # Apply sharpening and denoising in one step
    cropped_img = cv2.bilateralFilter(cropped_img, 9, 75, 75)  # Denoise
    kernel = np.array([[0, -1, 0], [-1, 5, -1], [0, -1, 0]])  # Sharpening filter
    cropped_img = cv2.filter2D(cropped_img, -1, kernel)  # Sharpen

    temp_file_path = None

    # Save to tempfile
    with tempfile.NamedTemporaryFile(delete=False, suffix='.jpg') as temp_file:
        temp_file.write(cv2.imencode('.jpg', cropped_img)[1].tobytes())
        temp_file_path = temp_file.name

    return temp_file_path

@plateRecognizer.tool
async def recognize(ctx: RunContext[Deps]) -> LicensePlate:
    """
    Recognize and extract the license plate number from the cropped image.

    Args:
        ctx (RunContext[Deps]): The context containing dependencies, including the image path.

    Returns:
        LicensePlate: An instance containing the recognized plate number.

    Raises:
        InvalidArgument: If the image data is invalid or cannot be processed.
        OCRProcessingError: If OCR fails to recognize the plate number.
    """
    image = load_image(ctx.deps.image_path)
    image_data = encode_image(image)
    os.remove(ctx.deps.image_path)
    result = None
    
    prompt = """You are state-of-the-art OCR. Identify the plate number from the given image.
                Please double-check illegal characters and the alike numbers and characters,
                like 8 and B, 0 and O, W and H, 5 and 3, and V and Y.
                Regex will normally be like this: [A-Z]{3}[0-9]{4} or [0-9]{3}[A-Z]{3} or [A-Z]{3}[0-9]{3},
                Return in legal JSON format. The JSON object must use the schema: {\"number\": \"{PLATE_NUMBER_HERE}\"}"""
    retry = 0
    max_retries = 3
    while not result or len(result) == 0:
        if retry >= max_retries:
            break
        retry += 1
        response = client.chat.completions.create(
            model="llama-3.2-90b-vision-preview",
            messages=[
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "text",
                            "text": prompt,
                        },
                        {
                            "type": "image_url",
                            "image_url": {
                                "url": f"data:image/jpeg;base64,{image_data}"
                            }
                        },
                    ],
                }
            ],
            response_format={"type": "json_object"},
        )
        result = response.choices[0].message.content
    
    result = LicensePlate.model_validate_json(result)
    result.number = normalize_number(result.number)
    return result

class PlateRecognizer(object):
    
    def __init__(self, image_path: str):
        self.image_path = image_path
        
    async def recognize(self) -> LicensePlate:
        deps = Deps(self.image_path)
        try:
            result = await plateExtractor.run(f'Extract the cropped image of plate from the given image', deps=deps)
            deps.image_path = result.data.image_path
            print(deps.image_path)
            result = await plateRecognizer.run('Recognize the plate number', deps=deps)
        except RateLimitError as e:
            print(f"Rate limit error: {e}")
            plateExtractor.model = OpenAIModel('gpt-4o-mini', api_key=os.environ['OPENAI_API_KEY'])
            plateRecognizer.model = OpenAIModel('gpt-4o-mini', api_key=os.environ['OPENAI_API_KEY'])
            return await self.recognize()
            # plateExtractor.model = GroqModel('llama3-groq-8b-8192-tool-use-preview', api_key=os.environ['GROQ_API_KEY'])
            # plateRecognizer.model = GroqModel('llama3-groq-8b-8192-tool-use-preview', api_key=os.environ['GROQ_API_KEY'])
            
        return result.data