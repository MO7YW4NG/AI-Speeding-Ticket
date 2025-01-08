import json
import main
import be
from fastapi import UploadFile
from datetime import datetime
import os
from io import BytesIO

# Function to read a JSON file
def read_json_file(file_path):
    with open(file_path, 'r', encoding="utf-8") as file:
        data = json.load(file)
    return data

# Function to get the district from the address
def get_district(address):
    start = address.find('市') + 1
    end = address.find('區') + 1
    if start > 0 and end > start:
        return address[start:end]
    return None

# Function to get the plate number from the photo
async def get_plate_number(photo_path):
    # Construct the full path to the image file
    photo_path = os.path.abspath(photo_path.replace('\\', '/').lstrip('/'))
    if os.path.exists(photo_path):
        with open(photo_path, 'rb') as file:
            photo = file.read()
        # Create an UploadFile object from the photo content
        upload_file = UploadFile(filename=photo_path, file=BytesIO(photo))
        plate_number = await main.recognize_license_plate(upload_file)
        return plate_number
    else:
        print(f"Failed to retrieve the image. File not found: {photo_path}")
        return None

async def insert_new_violation(file_path):
    data = read_json_file(file_path) 
    
    for entry in data['entries']:
        photo_path = entry['photo_path']
        plate_number = await get_plate_number(photo_path)
        # print(f"Plate Number: {plate_number}")

        if plate_number is not None:
            if plate_number.confidence >= 0.9:
                entry['plate_number'] = plate_number.number
                entry['recognize'] = 0

            elif plate_number.confidence < 0.9 and plate_number.confidence > 0:
                entry['plate_number'] = plate_number.number
                entry['recognize'] = 1
            else:
                entry['plate_number'] = None
                entry['recognize'] = 1
        else:
            print("Failed to get the plate number.")
    
        # Extract date and time from datetime
        dt = datetime.fromisoformat(entry['datetime'])
        entry['date'] = dt.date().isoformat()
        entry['time'] = dt.time().isoformat()

        lon, long = await main.get_geocode(entry['address'])
        entry['longitude'] = lon
        entry['latitude'] = long

        entry['district'] = get_district(entry['address'])

    print(data)

    # Send the updated data to the database
    await be.insert_new_violation(data)

