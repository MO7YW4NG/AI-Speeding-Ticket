from fastapi import APIRouter  # Changed from FastAPI import
import psycopg
import main
import base64
import os

router = APIRouter()  # Initialize APIRouter instead of FastAPI

conninfo = f"dbname={os.environ['DB_DASHBOARD_DBNAME']} user={os.environ['DB_DASHBOARD_USER']} password={os.environ['DB_DASHBOARD_PASSWORD']} host={os.environ['DB_DASHBOARD_HOST']} port={os.environ['DB_DASHBOARD_PORT']}"

# Replace @app.get and @app.post with @router.get and @router.post
@router.get("/recognize_license_plate")
def recognize_license_plate():
    with psycopg.connect(conninfo,autocommit=True) as conn:
        with conn.cursor() as cursor:
            # Use parameterized query to safely insert the name
            sql = '''SELECT * FROM traffic_violation'''

            cursor.execute(sql)

            violations = cursor.fetchall()

            for violation in violations:
                image = violation[1] # assuming the image is in the second column
                license_plate = main.recognize_license_plate(image)
                print(license_plate)
        
@router.get("/violation/get_all_unrecognized")
def get_unrecognized_license_plates_by_AI():
    entries = []
    with psycopg.connect(conninfo,autocommit=True) as conn:
        with conn.cursor() as cursor:
    
            # Use parameterized query to safely insert the name
            sql = '''SELECT * FROM traffic_violation WHERE status_code IN (11, 12);''' # 11 / 12 means not recognized by AI
            
            cursor.execute(sql)
            
            fetched_entries = cursor.fetchall()
            
            for entry in fetched_entries:
                # Convert the bytea image to base64
                image_data = entry[10]  
                base64_image = base64.b64encode(image_data).decode('utf-8')

                entry = list(entry)
                entry[10] = base64_image
                entries.append(tuple(entry))
                
            return entries
        
@router.post("/violation/new")
def insert_new_violation(data):
    with psycopg.connect(conninfo, autocommit=True) as conn:
        with conn.cursor() as cursor:
            for entry in data['entries']:
                photo_path = entry['photo_path']
                photo_path = os.path.abspath(photo_path.replace('\\', '/').lstrip('/'))
                # Read the photo file as binary data
                with open(photo_path, 'rb') as file:
                    photo_data = file.read()

                # Use parameterized query to safely insert the name
                sql = '''INSERT INTO traffic_violation (violation_date, violation_time, device_id, 
                        speed_limit, vehicle_speed, license_plate, licenseplate_reply_date, licenseplate_reply_time,
                        vehicle_type, photo, status_code, district, address, longitude, latitude) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
                        '''
                
                cursor.execute(sql, (entry['date'], entry['time'], data['device_id'], entry['speed_limit'],
                                entry['vehicle_speed'], entry['plate_number'], entry['reply_date'], entry['reply_time'],
                                entry['vehicletype'], psycopg.Binary(photo_data), entry['status'], entry['district'], 
                                entry['address'], entry['longitude'], entry['latitude']))
                
        return ("New violation(s) added successfully.")
        
@router.post("/violation/update_license_plate")
def artificial_recognize_license_plate(violation_id, new_license_plate):
    with psycopg.connect(conninfo, autocommit=True) as conn:
        with conn.cursor() as cursor:
            
            sql =   '''  
                    UPDATE traffic_violation 
                    SET license_plate = %s, status_code = 0 
                    WHERE violation_id = %s;
                    '''
            
            cursor.execute(sql, (new_license_plate, violation_id))
        
        return ("License plate updated successfully.")

    
# @router.post("/violation/remove")
# def move_and_delete_unrecognized_license_plate(violation_id):
#     with psycopg.connect(conninfo,autocommit=True) as conn:
#         with conn.cursor() as cursor:

#             # Select the entry to be moved
#             select_sql =    '''
#                             SELECT violation_id, violation_date, violation_time, device_id, 
#                             speed_limit, vehicle_speed, license_plate, licenseplatereplydate, 
#                             licenseplatereplytime, vehicletype, vehiclestatuscode, photo, 
#                             recognize, license_plate2, location, address, longitude, latitude
#                             FROM trafficviolation WHERE violation_id = %s
#                             '''
#             cursor.execute(select_sql, (violation_id,))
#             violation = cursor.fetchone()
#             cursor.execute(select_sql, (violation_id,))
#             violation = cursor.fetchone()

#             if violation:
#                 # Insert the entry into the abandoned table
#                 insert_sql =    '''
#                                 INSERT INTO abandoned (violation_id, violation_date, violation_time, device_id, 
#                                 speed_limit, vehicle_speed, license_plate, licenseplatereplydate, 
#                                 licenseplatereplytime, vehicletype, vehiclestatuscode, photo, 
#                                 recognize, license_plate2, location, address, longitude, latitude)
#                                 VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
#                                 '''
                
#                 cursor.execute(insert_sql, violation) 

#                 # Delete the entry from the original table
#                 delete_sql = '''DELETE FROM trafficviolation WHERE violation_id = %s'''
#                 cursor.execute(delete_sql, (violation_id,))

#                 print("License plate moved and deleted successfully.")
#             else:
#                 print("Violation ID not found.")

@router.post("/violation/update_status")
def update_traffic_violation(violation_id, status_code):
    with psycopg.connect(conninfo,autocommit=True) as conn:
        with conn.cursor() as cursor:

            # Use parameterized query to safely insert the name
            sql = '''  
                    UPDATE traffic_violation 
                    SET status_code = %s
                    WHERE violation_id = %s;
                    '''
            
            # Execute the query with the 'name' argument passed as a parameter
            cursor.execute(sql, (status_code, violation_id,))
    
    return ("Traffic violation status updated successfully.")

@router.get("/violation/get_all")
def get_all_issuable_violations():
    entries = []
    with psycopg.connect(conninfo,autocommit=True) as conn:
        with conn.cursor() as cursor:

            # Use parameterized query to safely insert the name
            sql = '''SELECT * FROM traffic_violation where status_code = 0''' # 0 means recognized by AI and human

            # Execute the query with the 'name' argument passed as a parameter
            cursor.execute(sql)

            # Fetch the results
            fetched_entries = cursor.fetchall()
            
            for entry in fetched_entries:
                # Convert the bytea image to base64
                image_data = entry[10]  
                base64_image = base64.b64encode(image_data).decode('utf-8')
                
                entry = list(entry)
                entry[10] = base64_image
                entries.append(tuple(entry))
                
    return entries


@router.get("/vehicle/get")
def get_vehicle_details(plate_number):
    with psycopg.connect(conninfo,autocommit=True) as conn:
        with conn.cursor() as cursor:
    
            # Use parameterized query to safely insert the name
            sql = '''SELECT * FROM vehicle_registration WHERE license_plate = %s'''
            
            # Execute the query with the 'name' argument passed as a parameter
            cursor.execute(sql, (plate_number,))
            
            # Fetch the results
            result = cursor.fetchall()
    
    return result

@router.post("/violation/issue")
def update_traffic_violation(violation_id):
    with psycopg.connect(conninfo,autocommit=True) as conn:
        with conn.cursor() as cursor:

            # Use parameterized query to safely insert the name
            sql = '''UPDATE traffic_violation SET status_code = 30 WHERE violation_id = %s'''
            
            # Execute the query with the 'name' argument passed as a parameter
            cursor.execute(sql, (violation_id,))
    
    return ("Traffic violation issued successfully.")
