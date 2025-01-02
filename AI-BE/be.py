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
            sql = '''SELECT * FROM trafficviolation'''

            cursor.execute(sql)

            violations = cursor.fetchall()
            # return ("violation", violations)

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
            sql = '''SELECT * FROM trafficviolation WHERE recognize = 1''' # 1 means not recognized by AI
            
            cursor.execute(sql)
            
            fetched_entries = cursor.fetchall()
            
            for entry in fetched_entries:
                # Convert the bytea image to base64
                image_data = entry[11]  
                base64_image = base64.b64encode(image_data).decode('utf-8')

                entry = list(entry)
                entry[11] = base64_image
                entries.append(tuple(entry))
                
            return entries
        
@router.post("/violation/update")
def articial_recognize_license_plate(violation_id, new_license_plate):
    with psycopg.connect(conninfo,autocommit=True) as conn:
        with conn.cursor() as cursor:
    
            # Use parameterized query to safely insert the name
            sql =  '''UPDATE trafficviolation SET license_plate = %s AND recgonize = 0 WHERE violation_id = %s'''
            
            cursor.execute(sql, (new_license_plate, violation_id))
            
            print("License plate updated successfully.")
    
@router.post("/violation/remove")
def move_and_delete_unrecognized_license_plate(violation_id):
    with psycopg.connect(conninfo,autocommit=True) as conn:
        with conn.cursor() as cursor:

            # Select the entry to be moved
            select_sql = '''SELECT * FROM trafficviolation WHERE violation_id = %s'''
            cursor.execute(select_sql, (violation_id,))
            violation = cursor.fetchone()

            if violation:
                # Insert the entry into the abandoned table
                insert_sql = '''INSERT INTO abandoned (violation_id) VALUES (%s)'''
                cursor.execute(insert_sql, (violation[0]))

                # Delete the entry from the original table
                delete_sql = '''DELETE FROM trafficviolation WHERE violation_id = %s'''
                cursor.execute(delete_sql, (violation_id,))

                print("License plate moved and deleted successfully.")
            else:
                print("Violation ID not found.")

@router.get("/violation/get_all")
def get_all_issuable_violations():
    entries = []
    with psycopg.connect(conninfo,autocommit=True) as conn:
        with conn.cursor() as cursor:

            # Use parameterized query to safely insert the name
            sql = '''SELECT * FROM trafficviolation where recognize = 0''' # 0 means recognized by AI and human

            # Execute the query with the 'name' argument passed as a parameter
            cursor.execute(sql)

            # Fetch the results
            fetched_entries = cursor.fetchall()
            
            for entry in fetched_entries:
                # Convert the bytea image to base64
                image_data = entry[11]  
                base64_image = base64.b64encode(image_data).decode('utf-8')
                
                entry = list(entry)
                entry[11] = base64_image
                entries.append(tuple(entry))
                
    return entries

# print(get_all_issuable_violations())

@router.get("/vehicle/get")
def get_vehicle(plate_number):
    with psycopg.connect(conninfo,autocommit=True) as conn:
        with conn.cursor() as cursor:
    
            # Use parameterized query to safely insert the name
            sql = '''SELECT * FROM vehicles WHERE plateNumber = %s'''
            
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
            sql = '''UPDATE trafficviolation SET is_issued = 1 WHERE violation_id = %s'''
            
            # Execute the query with the 'name' argument passed as a parameter
            cursor.execute(sql, (violation_id,))
    
    print("Traffic violation updated successfully.")

@router.post("/delete_ticket")
def delete_ticket(license_plate):
    with psycopg.connect(conninfo,autocommit=True) as conn:
        with conn.cursor() as cursor:
            # Use parameterized query to safely insert the name
            sql = '''DELETE * FROM tickets WHERE license_plate = %s'''
            cursor.execute(sql, license_plate)

    print("Delete license plate successfully.")


# get_license_plate()
# print(get_driver())
# get_all_violation()
# print(get_all_driver())
# print(get_all_ticket())