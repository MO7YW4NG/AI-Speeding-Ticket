import psycopg2
from PIL import Image
import io

# 設定資料庫連線參數
db_params = {
    'dbname': 'dashboard',
    'user': 'postgres',
    'password': '1234',
    'host': 'localhost',
    'port': '5432'
}

# 連接到資料庫
try:
    conn = psycopg2.connect(**db_params)
    cursor = conn.cursor()
    print("成功連接到資料庫")
except Exception as e:
    print(f"無法連接到資料庫: {e}")
    exit()

# 查詢前 100 筆記錄
try:
    cursor.execute("SELECT violation_id, photo FROM traffic_violation WHERE violation_id BETWEEN 1 AND 100")
    records = cursor.fetchall()
    for record in records:
        violation_id, photo_id = record
        print(f"violation_id: {violation_id}")
        
        # 將 photo_id 讀取為圖片並顯示
        image = Image.open(io.BytesIO(photo_id))
        image.show()
except Exception as e:
    print(f"無法查詢資料: {e}")

# 關閉連線
cursor.close()
