import codecs
import os

# 指定源檔案路徑（使用原始字串）
source_file = r"C:\Users\aa932\Downloads\vehicle_registration_fixed.csv"

# 取得源檔案的路徑和檔名
source_dir = os.path.dirname(source_file)
source_filename = os.path.basename(source_file)

# 設定目標檔案的名稱
target_filename = source_filename.replace('.csv', '_utf8_cleaned.csv')

# 生成目標檔案的完整路徑
target_file = os.path.join(source_dir, target_filename)

# 打開 BIG5 編碼的檔案並將其內容讀取為 UTF-8，忽略錯誤字元
with codecs.open(source_file, 'r', 'big5', errors='replace') as infile:
    content = infile.read()

# 替換掉可能出現的無效字元（例如0xe7、0x3f等）
content = content.replace(chr(0xe7), '?')  # 替換不合法字元

# 將清理過的內容寫入新的 UTF-8 檔案
with codecs.open(target_file, 'w', 'utf-8') as outfile:
    outfile.write(content)

print(f"檔案已成功清理並保存為 {target_file}")
