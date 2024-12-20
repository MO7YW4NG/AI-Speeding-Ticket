from fastapi import FastAPI, File, UploadFile
from pydantic import BaseModel
from recognizer import PlateRecognizer
import tempfile
app = FastAPI()

class RecognizeResponse(BaseModel):
    license_plate: str

@app.post("/recognize", response_model=RecognizeResponse)
async def recognize_license_plate(file: UploadFile = File(...)):

    image = await file.read()
    plate = ''
    # write to tempfile
    with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as temp_file:
        temp_file.write(image)
        temp_file_path = temp_file.name
        recognizer = PlateRecognizer(temp_file_path)
        plate = await recognizer.recognize()

        return RecognizeResponse(license_plate=plate)
    return RecognizeResponse(license_plate=plate)