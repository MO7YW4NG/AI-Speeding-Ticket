from fastapi import FastAPI, File, UploadFile
import psycopg2
import main

app = FastAPI()

@app.get("/recognize_license_plate")
def recognize_license_plate():
    conn = psycopg2.connect(
        database='dashboardcar',
        user='postgres',
        password='1234',
        host='localhost',
        port='5432'
    )

    conn.autocommit = True
    cursor = conn.cursor()

    # Use parameterized query to safely insert the name
    sql = '''SELECT * FROM trafficviolation'''

    cursor.execute(sql)

    violations = cursor.fetchall()
    # return ("violation", violations)

    for violation in violations:
        image = violation[1] # assuming the image is in the second column
        license_plate = main.recognize_license_plate(image)
        print(license_plate)
        
@app.get("/get_unrecognized_license_plates_by_AI")
def get_unrecognized_license_plates_by_AI():
    conn = psycopg2.connect(
        database='dashboardcar',
        user='postgres',
        password='1234',
        host='localhost',
        port='5432'
    )
    
    conn.autocommit = True
    cursor = conn.cursor()
    
    # Use parameterized query to safely insert the name
    sql = '''SELECT * FROM trafficviolation WHERE recognize = 1''' # 1 means not recognized by AI
    
    cursor.execute(sql)
    
    entries = cursor.fetchall()
    
    return entries
        
@app.post("/articial_recognize_license_plate")
def articial_recognize_license_plate(violation_id, new_license_plate):
    conn = psycopg2.connect(
        database='dashboardcar',
        user='postgres',
        password='1234',
        host='localhost',
        port='5432'
    )
    
    conn.autocommit = True
    cursor = conn.cursor()
    
    # Use parameterized query to safely insert the name
    sql =  '''UPDATE trafficviolation SET license_plate = %s AND recgonize = 0 WHERE violation_id = %s'''
    
    cursor.execute(sql, (new_license_plate, violation_id))
    
    print("License plate updated successfully.")
    
@app.post("/move_and_delete_unrecognized_license_plate")
def move_and_delete_unrecognized_license_plate(violation_id):
    conn = psycopg2.connect(
        database='dashboardcar',
        user='postgres',
        password='1234',
        host='localhost',
        port='5432'
    )

    conn.autocommit = True
    cursor = conn.cursor()

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

    # Close the cursor and connection
    cursor.close()
    conn.close()
          
@app.get("/get_all_issuable_violations")
def get_all_issuable_violations():
    conn = psycopg2.connect(
        database='dashboardcar',
        user='postgres',
        password='1234',
        host='localhost',
        port='5432'
    )

    conn.autocommit = True
    cursor = conn.cursor()

    # Use parameterized query to safely insert the name
    sql = '''SELECT * FROM trafficviolation where recognize = 0''' # 0 means recognized by AI and human

    # Execute the query with the 'name' argument passed as a parameter
    cursor.execute(sql)

    # Fetch the results
    result = cursor.fetchall()
    for line in result:
        print(line)

    # Close the cursor and connection
    cursor.close()
    conn.close()

    return result

@app.get("/get_vehicle")
def get_vehicle(plate_number):
    conn = psycopg2.connect(
        database='dashboardcar',
        user='postgres',
        password='1234',
        host='localhost',
        port='5432'
    )
    
    conn.autocommit = True
    cursor = conn.cursor()
    
    # Use parameterized query to safely insert the name
    sql = '''SELECT * FROM vehicles WHERE plateNumber = %s'''
    
    # Execute the query with the 'name' argument passed as a parameter
    cursor.execute(sql, (plate_number,))
    
    # Fetch the results
    vehicle = cursor.fetchall()
    
    # Close the cursor and connection
    cursor.close()
    conn.close()
    
    return vehicle

# @app.get("/get_driver")
# def get_driver(plate_number):
#     conn = psycopg2.connect(
#         database='dashboardcar',
#         user='postgres',
#         password='1234',
#         host='localhost',
#         port='5432'
#     )

#     conn.autocommit = True
#     cursor = conn.cursor()

#     # Use parameterized query to safely insert the name
#     sql = '''SELECT * FROM drivers WHERE plateNumber = %s'''

#     # Execute the query with the 'name' argument passed as a parameter
#     cursor.execute(sql, (plate_number,))

#     # Fetch the results
#     driver = cursor.fetchall()

#     # Close the cursor and connection
#     cursor.close()
#     conn.close()

#     return driver

@app.get("/get_all_driver")
def get_all_driver():
    conn = psycopg2.connect(
        database='dashboardcar',
        user='postgres',
        password='1234',
        host='localhost',
        port='5432'
    )

    conn.autocommit = True
    cursor = conn.cursor()

    # Use parameterized query to safely insert the name
    sql = '''SELECT * FROM drivers'''

    # Execute the query with the 'name' argument passed as a parameter
    cursor.execute(sql)

    # Fetch the results
    drivers = cursor.fetchall()

    # Close the cursor and connection
    cursor.close()
    conn.close()

    return drivers

@app.post("/new_ticket")
def new_ticket(image, location, coordinate, datetime, equipment_id, speedlimit, speed, plate_number, vehicle_type, is_recognized):
    conn = psycopg2.connect(
        database='dashboardcar',
        user='postgres',
        password='1234',
        host='localhost',
        port='5432'
    )

    conn.autocommit = True
    cursor = conn.cursor()

    #
    sql = '''INSERT INTO tickets (image, location, coordinate, datetime, equipment_id, speedlimit, speed, plate_number, vehicle_type, is_recognized) 
             VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'''

    # Execute the query with the parameters (name, age, license_number, image)
    cursor.execute(sql, (image, location, coordinate, datetime, equipment_id, speedlimit, speed, plate_number, vehicle_type, is_recognized))

    # Close the cursor and connection
    cursor.close()
    conn.close()

    print("Ticket submitted successfully")

@app.get("/get_all_ticket")
def get_all_ticket(license_number):
    conn = psycopg2.connect(
        database='dashboardcar',
        user='postgres',
        password='1234',
        host='localhost',
        port='5432'
    )

    conn.autocommit = True
    cursor = conn.cursor()

    # Use parameterized query to safely insert the name
    sql = '''SELECT * FROM tickets WHERE is_recognized = true'''

    # Execute the query with the 'name' argument passed as a parameter
    cursor.execute(sql)

    # Fetch the results
    tickets = cursor.fetchall()

    # Close the cursor and connection
    cursor.close()
    conn.close()

    return tickets

@app.get("/get_all_unrecognized_ticket")
def get_all_unrecognized_ticket():
    conn = psycopg2.connect(
        database='dashboardcar',
        user='postgres',
        password='1234',
        host='localhost',
        port='5432'
    )

    conn.autocommit = True
    cursor = conn.cursor()

    # Use parameterized query to safely insert the name
    sql = '''SELECT * FROM tickets WHERE is_recognized = false'''

    # Execute the query with the 'name' argument passed as a parameter
    cursor.execute(sql)

    # Fetch the results
    tickets = cursor.fetchall()

    # Close the cursor and connection
    cursor.close()
    conn.close()

    return tickets

@app.post("/update_ticket")
def update_ticket(license_plate):
    conn = psycopg2.connect(
        database='dashboardcar',
        user='postgres',
        password='1234',
        host='localhost',
        port='5432'
    )

    conn.autocommit = True
    cursor = conn.cursor()

    # Use parameterized query to safely insert the name
    sql = '''UPDATE * FROM tickets WHERE license_plate = %s'''

    cursor.execute(sql, license_plate)

    print("Update license plate successfully.")

@app.post("/delete_ticket")
def delete_ticket(license_plate):
    conn = psycopg2.connect(
        database='dashboardcar',
        user='postgres',
        password='1234',
        host='localhost',
        port='5432'
    )

    conn.autocommit = True
    cursor = conn.cursor()

    # Use parameterized query to safely insert the name
    sql = '''DELETE * FROM tickets WHERE license_plate = %s'''
    cursor.execute(sql, license_plate)

    print("Delete license plate successfully.")


# get_license_plate()
# print(get_driver())
get_all_violation()
# print(get_all_driver())
# print(get_all_ticket())