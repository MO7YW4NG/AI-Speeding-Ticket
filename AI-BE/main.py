from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from recognizer import PlateRecognizer, ExtractedPlate
from geocoding import get_geocode
import tempfile
import time
from fastapi.staticfiles import StaticFiles
# import os
from be import router as be_router  # Import the router from be.py
from violation import insert_new_violation, print_letter, PrinterData
from geojson import get_today_violations_geojson

app = FastAPI()

origins = [
    "*",
]

app.mount("/static", StaticFiles(directory="static"), name="static")

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/recognize", response_model=ExtractedPlate)
async def recognize_license_plate(file: UploadFile = File(...)):
    start = time.time()
    plate = None
    # write to tempfile
    with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as temp_file:
        temp_file.write(await file.read())
        temp_file_path = temp_file.name
        recognizer = PlateRecognizer(temp_file_path)
        plate = await recognizer.recognize()
    
    # os.remove(temp_file_path)
    
    print(f"Time taken: {time.time() - start}")
    return plate

@app.post("/geocoding")
async def geocoding(address: str):
    return await get_geocode(address)

@app.post("/process-violations")
async def process_violations(file_path: str):
    await insert_new_violation(file_path)
    return {"status": "Processing completed"}

@app.get("/today-violations-geojson")
async def get_today_violations():
    return await get_today_violations_geojson()

@app.post("/print-letter")
async def letter_print(data: PrinterData):
    await print_letter(data)
    return {"status": "Printing completed"}

app.include_router(be_router)

