from pydantic_ai import Agent, RunContext, ModelRetry
# from pydantic_ai.models.gemini import GeminiModel
from pydantic_ai.models.groq import GroqModel
from pydantic_ai.models.openai import OpenAIModel
from pydantic_ai.exceptions import UnexpectedModelBehavior
from pydantic import BaseModel, Field
# from dotenv import load_dotenv
from dataclasses import dataclass
from typing import Annotated
import os
import cv2
import numpy as np
import tempfile
# import google.generativeai as genai
from google.api_core.exceptions import InvalidArgument 
from openai import AsyncOpenAI, RateLimitError
# from groq import AsyncGroq, RateLimitError
# import json
import time
import base64

# load_dotenv()
# Initialize the Groq model with API key
# agentModel = OpenAIModel('gpt-4o-mini', api_key=os.environ['OPENAI_API_KEY'])
agentModel = OpenAIModel('llama3-groq-70b-8192-tool-use-preview', base_url='https://api.groq.com/openai/v1', api_key=os.environ['GROQ_API_KEY'])
# genai.configure(api_key=os.environ['GEMINI_API_KEY'])
genai = AsyncOpenAI(api_key=os.environ["GEMINI_API_KEY"],
        base_url="https://generativelanguage.googleapis.com/v1beta/openai/")
# Initialize Groq client with API key
# client = AsyncGroq(api_key=os.environ['GROQ_API_KEY'])
client = AsyncOpenAI(api_key=os.environ["GROQ_API_KEY"],
                     base_url="https://api.groq.com/openai/v1")

@dataclass
class Deps:
    image_path: str

@dataclass
class BoundingBox(BaseModel):
    coordinates: Annotated[list[float], Field(description="Bounding box coordinates in the format [ymin, xmin, ymax, xmax]")]
    recog_result: Annotated[int, Field(strict=True, ge=0, le=2, description="Recognition result: 0 if one plate detected, 1 if multiple plates detected, 2 if no plate detected or image is unrecognizable")]

@dataclass
class ExtractedPlate(BaseModel):
    recog_result: Annotated[int, Field(0, strict=True, ge=0, le=2, description="Passed from the plate_detection tool")]
    number: Annotated[str, Field(description="Recognized license plate number")]
    confidence: Annotated[float, Field(description="Confidence score of the recognition; set to 0 if not confident or unclear")]

# visionModel = [
    # genai.GenerativeModel(
    #     "gemini-1.5-flash",
    #     generation_config=genai.GenerationConfig(
    #         response_mime_type="application/json",
    #         response_schema=BoundingBox
    #     )
    # ),
    # genai.GenerativeModel(
    #     "gemini-2.0-flash-exp",
    #     generation_config=genai.GenerationConfig(
    #         response_mime_type="application/json",
    #         response_schema=BoundingBox
    #     )
    # ),
# ]

plateExtractor = Agent(
    agentModel,
    system_prompt=(
        'Be concise, reply with one sentence.'
        'Your job is to extract the license plate and recognize its number from the given image.'
        'First, you must use `plate_detection` tool to get the coordinates of the plate and recog_result.'
        'If the recog_result is 1 or 2, terminate the process.'
        'If a plate is detected, use `crop_image` tool to crop the image,'
        'then use `recognize` tool to recognize the number.'
        ),
    result_type=ExtractedPlate,
    deps_type=Deps
)

# plateRecognizer = Agent(
#     agentModel,
#     system_prompt=(
#         'Be concise, reply with one sentence.'
#         'Your job is to extract the license plate and recognize its number from the given image.'
#         'First, you must use `plate_detection` tool to get the coordinates of the plate and the recognition result.'
#         'If the recog_result is 1 or 2, terminate the process.'
#         'If a plate is detected, use `crop_image` tool to crop the image,'
#         'then use `recognize` tool to recognize the number.'
#         ),
#     result_type=ExtractedPlate,
#     deps_type=Deps
# )

def load_image(image_path):
    """Load an image from the specified file path."""
    return cv2.imread(image_path, cv2.IMREAD_COLOR)

def encode_image(image):
    """Encode the image to a base64 string."""
    _, buffer = cv2.imencode('.jpg', image)
    return base64.b64encode(buffer).decode('utf-8')

def normalize_number(plate_number: str) -> str:
    """
    Normalize the license plate number by converting to uppercase and removing specific characters.
    
    Args:
        plate_number (str): The license plate number to normalize.
    
    Returns:
        str: The normalized license plate number.
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
async def plate_detection(ctx: RunContext[Deps]) -> BoundingBox:
    """
    Extract the bounding coordinates of the most prominent license plate from the provided image.
    
    Args:
        ctx (RunContext[Deps]): Context containing dependencies, including the image path.
    
    Returns:
        BoundingBox: A dictionary with coordinates and the detection result.
    
    Raises:
        ModelRetry: If the image file is not found or invalid.
    """
    if not os.path.exists(ctx.deps.image_path):
        raise ModelRetry("File not found")
    
    image = load_image(ctx.deps.image_path)
    data = encode_image(image)

    prompt = '''Return bounding boxes for license plate in the given image. MUST include the entire plate.
        1. If multiple plates are detected, terminate process, and return 1.
        2. If no plate is detected or the image is unrecognizable, terminate process, and return 2.
        3. If only one plate is successfully detected, continue and return 0.
        '''
    try:
        response = await genai.beta.chat.completions.parse(model="gemini-2.0-flash-exp",messages=
            [
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "text",
                            "text": prompt,
                        },
                        {
                            "type": "image_url",
                            "image_url":{
                                "url": f"data:image/jpeg;base64,{data}"
                            }
                        }
                    ]
                }
            ],
            response_format=BoundingBox
        )
    except InvalidArgument as e:
        print(e)
        # file = genai.upload_file(ctx.deps.image_path)
        # response = visionModel[1].generate_content(
        #     [
        #         prompt,
        #         file
        #     ]
        # )
        # genai.delete_file(file)
    result = response.choices[0].message.parsed
    print(result)
    return result
 
KERNEL = np.array([[0, -1, 0], [-1, 5, -1], [0, -1, 0]])
EXTEND = 15

@plateExtractor.tool
async def crop_image(ctx: RunContext[Deps], plate_coordinates: list[float]) -> str:
    """
    Crop the license plate area from the image based on the provided bounding coordinates.
    
    Args:
        ctx (RunContext[Deps]): Context containing dependencies, including the image path.
        plate_coordinates (list[float]): Bounding box coordinates [ymin, xmin, ymax, xmax].
    
    Returns:
        str: File path to the cropped image.
    
    Raises:
        ModelRetry: If the image file is not found.
        ValueError: If the bounding coordinates are invalid.
    """
    if not os.path.exists(ctx.deps.image_path):
        raise ModelRetry("File not found")
    img = load_image(ctx.deps.image_path)
    
    if len(plate_coordinates) != 4:
        return None
    if plate_coordinates[0] <= 1:
        plate_coordinates = [coord * 1000 for coord in plate_coordinates]

    height, width, _ = img.shape
    abs_x1 = max(int(plate_coordinates[1] / 1000 * width) - EXTEND, 0)
    abs_y1 = max(int(plate_coordinates[0] / 1000 * height) - EXTEND, 0)
    abs_x2 = min(int(plate_coordinates[3] / 1000 * width) + EXTEND, width)
    abs_y2 = min(int(plate_coordinates[2] / 1000 * height) + EXTEND, height)

    cropped_img = img[abs_y1:abs_y2, abs_x1:abs_x2]
    
    cropped_img = cv2.cvtColor(cropped_img, cv2.COLOR_BGR2GRAY)  # Convert to grayscale
    cropped_img = cv2.bilateralFilter(cropped_img, 9, 75, 75)    # Apply bilateral filter for denoising
    cropped_img = cv2.equalizeHist(cropped_img)                 # Perform histogram equalization
    cropped_img = cv2.filter2D(cropped_img, -1, KERNEL)         # Sharpen the image
    # _, cropped_img = cv2.threshold(cropped_img, 127, 255, cv2.THRESH_BINARY)  # Apply thresholding if needed

    temp_file_path = None

    # Save the cropped image to a temporary file
    with tempfile.NamedTemporaryFile(delete=False, suffix='.jpg') as temp_file:
        temp_file.write(cv2.imencode('.jpg', cropped_img)[1].tobytes())
        temp_file_path = temp_file.name

    return temp_file_path

@plateExtractor.tool
async def recognize(ctx: RunContext[Deps]) -> ExtractedPlate:
    """
    Recognize and extract the license plate number from the cropped image.
    
    Args:
        ctx (RunContext[Deps]): Context containing dependencies, including the image path.
    
    Returns:
        ExtractedPlate: Recognized plate number and associated confidence score.
    
    Raises:
        ModelRetry: If the image file is not found or invalid.
        OCRProcessingError: If OCR fails to recognize the plate number.
    """
    if not os.path.exists(ctx.deps.image_path):
        raise ModelRetry("File not found")
    
    image = load_image(ctx.deps.image_path)
    image_data = encode_image(image)
    os.remove(ctx.deps.image_path)
    result = None
    
    prompt = """Act as a state-of-the-art OCR. Your task is to analyze the given image, extract the textual content, and provide a confidence score for the extracted text.
                1. Recognize the license plate number from the image.
                2. The regex pattern will typically be: [A-Z]{3}[0-9]{4}, [0-9]{3}[A-Z]{3}, or [A-Z]{3}[0-9]{3}.
                3. Check for illegal characters and similar-looking characters like (8, B), (0, O), (W, H, N, M), (5, 3), and (V, Y). If indistinguishable, return '0' as the plate number and a confidence score of 0.
                4. The confidence score should be a float between 0 and 1.
                5. The JSON response must follow the schema: {\"number\": \"{PLATE_NUMBER_HERE}\", \"confidence\": {CONFIDENCE_SCORE_HERE}}.
                """
    retry = 0
    MAX_RETRIES = 3
    while not result or len(result) == 0:
        if retry >= MAX_RETRIES:
            break
        retry += 1
        response = await client.chat.completions.create(
        # response = await client.chat.completions.create(
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
            # response_format=ExtractedPlate,
            response_format={"type": "json_object"},
            temperature=0
        )
        result = response.choices[0].message.content
        
    result = ExtractedPlate.model_validate_json(result)
    result.number = normalize_number(result.number)
    print(result)
    return result

class PlateRecognizer(object):
    """Class to handle the recognition of license plates from images."""
    
    def __init__(self, image_path: str):
        """
        Initialize the PlateRecognizer with the path to the image.
        
        Args:
            image_path (str): Path to the image containing the license plate.
        """
        self.image_path = image_path
        
    async def recognize(self) -> ExtractedPlate:
        """
        Execute the plate extraction and recognition process.
        
        Returns:
            ExtractedPlate: The result containing the plate number and confidence score.
        """
        deps = Deps(self.image_path)
        try:
            result = await plateExtractor.run(
                'Extract the license plate number from the given image', 
                deps=deps
            )
        # result = await plateExtractor.run("Recognize the plate number from the given image", deps=result.data)
            # Uncomment the following line if using a separate recognizer agent
            # result = await plateRecognizer.run('Recognize the plate number from the given image', deps=result.data)
        # except Exception as e:
        except RateLimitError as e:
            print(f"Rate limit error: {e}")
            time.sleep(0.3)
            # Switch to OpenAI model in case of rate limiting
            # plateExtractor.model = GroqModel('llama3-groq-8b-8192-tool-use-preview', api_key=os.environ['GROQ_API_KEY'])
            if 'llama3-groq-70b-8192-tool' in e.message:
                plateExtractor.model = OpenAIModel('gpt-4o-mini', api_key=os.environ['OPENAI_API_KEY'])
            # Uncomment the following line if using a separate recognizer agent
            # plateRecognizer.model = OpenAIModel('gpt-4o-mini', api_key=os.environ['OPENAI_API_KEY'])
            return await self.recognize()
            # Alternative fallback to Groq model
            # plateRecognizer.model = GroqModel('llama3-groq-8b-8192-tool-use-preview', api_key=os.environ['GROQ_API_KEY'])
        except UnexpectedModelBehavior as e:
            print(f"Unexpected model behavior: {e}")
            return await self.recognize()
        return result.data