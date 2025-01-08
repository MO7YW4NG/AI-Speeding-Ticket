import os

def convert_big5_to_utf8(input_file, output_file):
    try:
        print(f"正在打開文件：{input_file}")
        if not os.path.exists(input_file):
            print(f"文件不存在：{input_file}")
            return
        
        with open(input_file, 'r', encoding='big5') as infile:
            content = infile.read()
            print("文件讀取成功")
        
        print(f"正在寫入文件：{output_file}")
        with open(output_file, 'w', encoding='utf-8') as outfile:
            outfile.write(content)
            print("文件寫入成功")
        
        print(f"轉換完成：{input_file} -> {output_file}")
    except Exception as e:
        print(f"轉換失敗：{e}")

# 使用範例
input_csv = r"C:\Users\aa932\Desktop\convert.csv"  # Big5 編碼的原始文件
output_csv = r"C:\Users\aa932\Desktop\valid.csv"  # 轉換後的 UTF-8 文件

print(f"開始轉換：{input_csv} -> {output_csv}")
convert_big5_to_utf8(input_csv, output_csv)
print("轉換函數執行完畢")
