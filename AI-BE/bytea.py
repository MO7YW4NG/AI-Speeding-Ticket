import os
import psycopg2

# 設定圖片資料夾路徑
image_folder = "images/"  # 修改為正確的資料夾名稱

# 儲存轉換結果的字典 {圖片名稱: bytes 資料}
image_bytes_dict = {}

# 檢查資料夾是否存在
if os.path.exists(image_folder) and os.path.isdir(image_folder):
    # 獲取資料夾內的所有檔案
    for file_name in os.listdir(image_folder):
        image_path = os.path.join(image_folder, file_name)
        # 檢查是否為檔案且副檔名為圖片格式（如 .jpg, .png）
        if os.path.isfile(image_path) and file_name.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp', '.gif')):
            try:
                # 以二進位模式讀取檔案
                with open(image_path, "rb") as image_file:
                    image_bytes = image_file.read()
                    # 儲存到字典中
                    image_bytes_dict[file_name] = image_bytes
                print(f"成功處理圖片：{file_name}")
            except Exception as e:
                print(f"無法處理圖片 {file_name}: {e}")
        else:
            print(f"跳過非圖片檔案：{file_name}")
else:
    print(f"資料夾不存在：{image_folder}")

# 設定資料庫連線參數
db_params = {
    'dbname': 'your_db_name',
    'user': 'your_db_user',
    'password': 'your_db_password',
    'host': 'your_db_host',
    'port': 'your_db_port'
}

# 連接到資料庫
try:
    conn = psycopg2.connect(
    database='dashboard',
    user='postgres',
    password='1234',
    host='localhost',
    port='5432'
    )
    cursor = conn.cursor()
    print("成功連接到資料庫")
except Exception as e:
    print(f"無法連接到資料庫: {e}")
    exit()

# 取前 100 張圖片
image_items = list(image_bytes_dict.items())[:100]

# 更新到資料庫
for idx, (file_name, image_bytes) in enumerate(image_items):
    try:
        print(f"正在更新圖片：{file_name} 到資料庫，violation_id={idx + 1}")
        cursor.execute("UPDATE traffic_violation SET photo = %s WHERE violation_id = %s", (psycopg2.Binary(image_bytes), idx + 1))
        print(f"成功更新圖片：{file_name} 到資料庫")
    except Exception as e:
        print(f"無法更新圖片 {file_name} 到資料庫: {e}")

# 提交變更並關閉連線
conn.commit()
cursor.close()
conn.close()
print("已處理並更新前 100 張圖片到資料庫")

# 顯示處理結果
print(f"已處理 {len(image_bytes_dict)} 張圖片！")
