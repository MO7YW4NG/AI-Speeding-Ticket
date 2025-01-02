from fastapi import FastAPI, File, UploadFile
import psycopg2
import main

app = FastAPI()

@app.get("/recognize_license_plate")
def recognize_license_plate():
    conn = psycopg2.connect(
        database='dashboard',
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
        
@app.get("/violation/get_all_unrecognized")
def get_unrecognized_license_plates_by_AI():
    conn = psycopg2.connect(
        database='dashboard',
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
        
@app.post("/violation/update")
def articial_recognize_license_plate(violation_id, new_license_plate):
    conn = psycopg2.connect(
        database='dashboard',
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
    
@app.post("/violation/remove")
def move_and_delete_unrecognized_license_plate(violation_id):
    conn = psycopg2.connect(
        database='dashboard',
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
          
@app.get("/violation/get_all")
def get_all_issuable_violations():
    conn = psycopg2.connect(
        database='dashboard',
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

@app.get("/vehicle/get")
def get_vehicle(plate_number):
    conn = psycopg2.connect(
        database='dashboard',
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
    result = cursor.fetchall()
    
    # Close the cursor and connection
    cursor.close()
    conn.close()
    
    return result

@app.post("/violation/issue")
def update_traffic_violation(violation_id):
    conn = psycopg2.connect(
        database='dashboard',
        user='postgres',
        password='1234',
        host='localhost',
        port='5432'
    )

    conn.autocommit = True
    cursor = conn.cursor()

    # Use parameterized query to safely insert the name
    sql = '''UPDATE trafficviolation SET is_issued = 1 WHERE violation_id = %s'''
    
    # Execute the query with the 'name' argument passed as a parameter
    cursor.execute(sql, (violation_id,))
    
    print("Traffic violation updated successfully.")

@app.post("/delete_ticket")
def delete_ticket(license_plate):
    conn = psycopg2.connect(
        database='dashboard',
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
# get_all_violation()
# print(get_all_driver())
# print(get_all_ticket())