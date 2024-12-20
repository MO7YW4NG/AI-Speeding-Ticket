from pydantic_ai import Agent,RunContext
from pydantic_ai.models.gemini import GeminiModel
from pydantic import BaseModel
from dotenv import load_dotenv
from dataclasses import dataclass
import os
import cv2
import tempfile
import google.generativeai as genai
# from openai import AsyncOpenAI
# import ollama
import json
import base64

load_dotenv()
model = GeminiModel('gemini-1.5-flash', api_key=os.environ['GEMINI_API_KEY'])
genai.configure(api_key=os.environ['GEMINI_API_KEY'])
# client = AsyncOpenAI(api_key=os.environ['OPENAI_API_KEY'])
# client = ollama.AsyncClient(host='http://localhost:11434')

@dataclass
class Deps:
    image_path: str

@dataclass
class LicensePlate(BaseModel):
    plate_number: str

class BoundingBox(BaseModel):
    coordinates: list[int]
    
plateExtractor = Agent(model, system_prompt='Extract the exact image of plate from given image', result_type=Deps, retries=0)
plateRecognizer = Agent(model, system_prompt='Recognize the plate number from given image', result_type=LicensePlate, retries=0)

# Function to encode the image
def encode_image(image_path):
  with open(image_path, "rb") as image_file:
    return base64.b64encode(image_file.read()).decode('utf-8')

@plateExtractor.tool
async def extract_plate_loc(ctx: RunContext[Deps]) -> list[int]:
    """Tool to get bounding boxes of license plate."""
    
    # Interact with AsyncOpenAI client
    # response = await client.beta.chat.completions.parse(
    #     model="gpt-4o",
    #     messages=[
    #         {
    #             "role": "user",
    #             "content": [
    #                 {"type": "text", "text": "Return bounding boxes (bottom-left and upper-right corners) for the license plate in JSON format, for example: [ymin, xmin, ymax, xmax]"},
    #                 {
    #                     "type": "image_url",
    #                     "image_url": {
    #                         "url": f"data:image/jpeg;base64,{encode_image(ctx.deps.image_path)}"
    #                     }
    #                 },
    #             ],
    #         }
    #     ],
    #     response_format=BoundingBox,
    # )

    model = genai.GenerativeModel("gemini-1.5-flash",
                                    generation_config=genai.GenerationConfig(
                                        response_mime_type="application/json",
                                        response_schema=list[int]
                                    )
                                )
    response = model.generate_content([{'mime_type':'image/jpeg', 'data': encode_image(ctx.deps.image_path)}, 'Return bounding boxes for the license plate in JSON format, for example: [ymin, xmin, ymax, xmax]'])

    # print(response)
    return json.loads(response.text)
    # return BoundingBox.model_validate_json(response.choices[0].message.content).coordinates
 
@plateExtractor.tool
async def crop_image(ctx: RunContext[Deps], plate_coordinates: list[int]) -> str:
    """Tool to crop image, then return cropped image file path."""
    # Convert bytes to numpy array
    img = cv2.imread(ctx.deps.image_path, cv2.IMREAD_COLOR)

    height, width, _ = img.shape
    abs_x1 = int(plate_coordinates[1]/1000 * width)
    abs_y1 = int(plate_coordinates[0]/1000 * height)
    abs_x2 = int(plate_coordinates[3]/1000 * width)
    abs_y2 = int(plate_coordinates[2]/1000 * height)

    cropped_img = img[abs_y1:abs_y2, abs_x1:abs_x2]
    cropped_img = cv2.cvtColor(cropped_img, cv2.COLOR_BGR2GRAY)
    
    temp_file_path = None

    # save to tempfile
    with tempfile.NamedTemporaryFile(delete=False, suffix='.jpg') as temp_file:
        temp_file.write(cv2.imencode('.jpg', cropped_img)[1].tobytes())
        temp_file_path = temp_file.name

    return temp_file_path

@plateRecognizer.tool
async def recognize(ctx: RunContext[Deps]) -> LicensePlate:
    """Tool to recognize the plate number from the cropped image."""
    
    model = genai.GenerativeModel("gemini-1.5-flash",
                               system_instruction='Identify the plate number from the given image',
                               generation_config={
                                    "response_mime_type": "application/json",
                                    "response_schema": LicensePlate
                               }
                            )
    
    response = model.generate_content(['Identify the plate number from the given image', {'mime_type':'image/jpeg', 'data': encode_image(ctx.deps.image_path)}])
    return LicensePlate.model_validate_json(response.text)

class PlateRecognizer(object):
    
    def __init__(self, image_path: str):
        self.image_path = image_path
        
    async def recognize(self) -> str:
        deps = Deps(self.image_path)
        result = await plateExtractor.run(f'Extract the cropped image of plate from the given image', deps=deps)
        deps.image_path = result.data.image_path
        print(deps.image_path)
        result = await plateRecognizer.run('Recognize the plate number', deps=deps)

        return result.data.plate_number