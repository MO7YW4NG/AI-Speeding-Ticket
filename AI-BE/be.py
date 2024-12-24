from fastapi import FastAPI, File, UploadFile
import psycopg2

app = FastAPI()


@app.get("/get_driver")
def get_driver(name):
    conn = psycopg2.connect(
        database='',
        user='',
        password='',
        host='',
        port='5432'
    )

    conn.autocommit = True
    cursor = conn.cursor()

    # Use parameterized query to safely insert the name
    sql = '''SELECT * FROM drivers WHERE NAME = %s'''

    # Execute the query with the 'name' argument passed as a parameter
    cursor.execute(sql, (name,))

    # Fetch the results
    driver = cursor.fetchall()

    # Close the cursor and connection
    cursor.close()
    conn.close()

    return driver


@app.get("/get_all_driver")
def get_all_driver():
    conn = psycopg2.connect(
        database='',
        user='',
        password='',
        host='',
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


@app.post("/upload")
def update(serialID, ip, employerID, category, date, license_number, file: UploadFile = File(...)):
    conn = psycopg2.connect(
        database='',
        user='',
        password='1234',
        host='',
        port='5432'
    )

    conn.autocommit = True
    cursor = conn.cursor()

    # Read the image file as binary
    with open(file, 'rb') as img_file:
        image_data = img_file.read()

    # SQL query to insert a new driver with an image
    sql = '''INSERT INTO drivers (serialID, ip, employerID, category, date, license_number, image) 
             VALUES (%s, %s, %s, %s, %s, %s, %s)'''

    # Execute the query with the parameters (name, age, license_number, image)
    cursor.execute(sql, (serialID, ip, employerID, category, date, license_number, image_data))

    # Close the cursor and connection
    cursor.close()
    conn.close()

    print("Driver added successfully with image")


@app.post("/new_ticket")
def new_ticket(reportID, employerID, date, ip, description):
    conn = psycopg2.connect(
        database='',
        user='',
        password='1234',
        host='',
        port='5432'
    )

    conn.autocommit = True
    cursor = conn.cursor()

    # Read the image file as binary

    # SQL query to insert a new driver with an image
    sql = '''INSERT INTO tickets (reportID, employerID, date, ip, description) 
             VALUES (%s, %s, %s, %s, %s)'''

    # Execute the query with the parameters (name, age, license_number, image)
    cursor.execute(sql, (reportID, employerID, date, ip, description))

    # Close the cursor and connection
    cursor.close()
    conn.close()

    print("Ticket submitted successfully")


@app.post("/send_ticket")
def get_all_ticket(license_number):
    conn = psycopg2.connect(
        database='',
        user='',
        password='1234',
        host='',
        port='5432'
    )

    conn.autocommit = True
    cursor = conn.cursor()

    # Use parameterized query to safely insert the name
    sql = '''SELECT * FROM tickets WHERE awaiting = true'''

    # Execute the query with the 'name' argument passed as a parameter
    cursor.execute(sql)

    # Fetch the results
    tickets = cursor.fetchall()

    # Close the cursor and connection
    cursor.close()
    conn.close()

    return tickets
