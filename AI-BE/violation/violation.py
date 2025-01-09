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

# Function to get the vehicle details from the plate number
async def get_vehicle_details(plate_number):
    if plate_number is not None:
        temp = be.get_vehicle_details(plate_number)
        print("Vehicle detail:", temp)
    if len(temp) > 0:
        if temp[0][5] == 0: # 0 means the owner is alive
            result = { "vehicletype": temp[0][2],
                    "vehiclestatuscode": 0}
            return result
        if temp[0][5] == 1: # 1 means the owner is dead
            result = { "vehicletype": temp[0][2],
                    "vehiclestatuscode": 24}
            return result
    else:
        result = { "vehicletype": "Not registered",
                   "vehiclestatuscode": 27}
        return result
    

async def insert_new_violation(file_path):
    data = read_json_file(file_path) 
    
    for entry in data['entries']:
        photo_path = entry['photo_path']
        plate_number = await get_plate_number(photo_path)

        current_datetime = datetime.now()

        reply_date = current_datetime.date().isoformat()
        reply_time = current_datetime.strftime("%H:%M:%S")
        print(f"Plate Number: {plate_number}")

        if plate_number is not None:
            if plate_number.recog_result == 1:  # 1 means multiple plate numbers
                entry['plate_number'] = "Unrecognized"
                entry['status'] = 11

            elif plate_number.recog_result == 2:  # 2 means recognition failed
                entry['plate_number'] = "Unrecognized"
                entry['status'] = 12
            elif plate_number.recog_result == 0:
                if plate_number.confidence >= 0.85:
                    entry['plate_number'] = plate_number.number
                    entry['status'] = 0
                elif plate_number.confidence < 0.85:
                    entry['plate_number'] = plate_number.number
                    entry['status'] = 12
            else:
                print("Plate number doesn't meet any condition above.")
        else:
            print("Failed to get the plate number.")

        if entry['status'] == 0:
            details = await get_vehicle_details(plate_number.number)
            entry['vehicletype'] = details['vehicletype']
            entry['status'] = details['vehiclestatuscode']
        else:
            entry['vehicletype'] = None
            entry['status'] = None
    
        # Extract date and time from datetime
        dt = datetime.fromisoformat(entry['datetime'])
        entry['date'] = dt.date().isoformat()
        entry['time'] = dt.time().isoformat()

        lon, long = await main.get_geocode(entry['address'])
        entry['longitude'] = lon
        entry['latitude'] = long

        entry['reply_date'] = reply_date
        entry['reply_time'] = reply_time

        entry['district'] = get_district(entry['address'])


    print(data)

    # Send the updated data to the database
    be.insert_new_violation(data)

    return ("Data inserted successfully.")

