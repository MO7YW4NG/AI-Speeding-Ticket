from fastapi import FastAPI, File, UploadFile
from recognizer import PlateRecognizer,ExtractedPlate
import tempfile
import time
from be import router as be_router  # Import the router from be.py
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

origins = [
    "*",
]

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

app.include_router(be_router)

