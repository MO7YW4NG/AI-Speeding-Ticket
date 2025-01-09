from PIL import Image, ImageDraw, ImageFont    
from datetime import timedelta, datetime
import io

BASE_IMG = 'base.jpg'
FONT_SIZE = 26
FONT_PATH = 'C:/Windows/fonts/kaiu.ttf'
COLOR = 'black'
PADDING = 20

def draw_texts(draw, font, texts_positions):
    for text, position in texts_positions:
        draw.text(position, text, font=font, fill=COLOR)

def resize_image(image, target_width):
    ratio = target_width / image.width
    target_height = int(image.height * ratio)
    return image.resize((target_width, target_height), Image.Resampling.LANCZOS)

def extend_image(base_image, attached_image):
    image_width, image_height = base_image.size
    attached_image = resize_image(attached_image, image_width - 2 * PADDING)
    
    padded_image = Image.new('RGB', (image_width, attached_image.height), 'white')
    padded_image.paste(attached_image, (PADDING, PADDING))
    
    new_height = image_height + attached_image.height + PADDING
    new_image = Image.new('RGB', (image_width, new_height), 'white')
    new_image.paste(base_image, (0, 0))
    new_image.paste(padded_image, (0, image_height))
    
    return new_image

def print_letter(data):
    texts_positions = [
        ('逕行舉發', (160, 230)),
        ('附採證照片', (160, 260)),
        ('限速    公里，經測時速    公里，', (640, 398)),
        ('超速    公里，', (640, 430)),
        ('本單可至郵局或超商門市繳納罰緩', (585, 228)),
        ('40       0       0', (788, 475)),
        (data['name'], (908, 315)),
        (data['plate_number'], (160, 315)),
        (data['addr'], (274, 358)),
        (data['vio_year'], (160, 398)),
        (data['vio_month'], (250, 398)),
        (data['vio_day'], (324, 398)),
        (data['vio_hour'], (400, 398)),
        (data['vio_minute'], (480, 398)),
        (data['location'], (160, 432)),
        (data['arrive_year'], (210, 466)),
        (data['arrive_month'], (320, 466)),
        (data['arrive_day'], (424, 466)),
        (data['fill_year'], (240, 750)),
        (data['fill_month'], (340, 750)),
        (data['fill_day'], (430, 750)),
        (data['range'], (824, 430)),
        (data['speed_limit'], (705, 398)),
        (data['speed'], (940, 398)),
        (data['speed_diff'], (705, 430)),
    ]
    
    image = Image.open(BASE_IMG)
    draw = ImageDraw.Draw(image)
    font = ImageFont.truetype(FONT_PATH, FONT_SIZE, encoding='unic')
    
    draw_texts(draw, font, texts_positions)
    
    attached_image = Image.open(io.BytesIO(data['photo']))
    image = extend_image(image, attached_image)
    
    image.save('output_image.pdf', 'PDF')
    image.save('output_image.jpg')

def generate_data():
    now = datetime.now()
    future = now + timedelta(days=15)
    
    speed = 80
    speed_limit = 60
    speed_diff = speed - speed_limit
    range_text = "超速"
    if speed_diff >= 80:
        range_text += '80公里以上'
    elif speed_diff >= 60:
        range_text += '60公里至80公里以內'
    elif speed_diff >= 40:
        range_text += '40公里至60公里以內'
    elif speed_diff >= 20:
        range_text += '20公里至40公里以內'
    else:
        range_text += '10公里至20公里以內'
    range_text += "。"
    
    return {
        'name': '王敏權',
        'addr': '新北市板橋區民族路167號adwa',
        'plate_number': 'ABC-1234',
        'vio_year': '114',
        'vio_month': '01',
        'vio_day': '09',
        'vio_hour': '09',
        'vio_minute': '12',
        'location': '新北市新北耶誕城',
        'arrive_year': str(future.year - 1911),
        'arrive_month': future.strftime('%m'),
        'arrive_day': future.strftime('%d'),
        'photo': open('attach.jpg', 'rb').read(),
        'fill_year': str(now.year - 1911),
        'fill_month': now.strftime('%m'),
        'fill_day': now.strftime('%d'),
        'speed': str(speed),
        'speed_limit': str(speed_limit),
        'speed_diff': str(speed_diff),
        'range': range_text,
    }

if __name__ == '__main__':
    data = generate_data()
    print_letter(data)