from fastapi import FastAPI, File, UploadFile
from pydantic import BaseModel
from recognizer import PlateRecognizer
import tempfile
import time


app = FastAPI()

class RecognizeResponse(BaseModel):
    license_plate: str

@app.post("/recognize", response_model=RecognizeResponse)
async def recognize_license_plate(file: UploadFile = File(...)):
    start = time.time()
    plate = None
    # write to tempfile
    with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as temp_file:
        temp_file.write(await file.read())
        temp_file_path = temp_file.name
        recognizer = PlateRecognizer(temp_file_path)
        plate = await recognizer.recognize()
        
    temp_file.close()
    
    print(f"Time taken: {time.time() - start}")
    return RecognizeResponse(license_plate=plate)