from PIL import Image, ImageDraw, ImageFont    
from datetime import timedelta, datetime
import io
from pydantic import BaseModel
import base64
BASE_IMG = 'violation/base.jpg'
FONT_SIZE = 26
FONT_PATH = 'violation/KAIU.TTF'
COLOR = 'black'
PADDING = 20

class PrinterData(BaseModel):
    name: str
    plate_number: str
    address: str
    vio_year: str
    vio_month: str
    vio_day: str
    vio_hour: str
    vio_minute: str
    location: str
    speed: int
    speed_limit: int
    photo: str
    

def draw_texts(draw: ImageDraw.ImageDraw, font, texts_positions: list[tuple[str, tuple[int, int]]]):
    for text, position in texts_positions:
        draw.text(position, text.strip(), font=font, fill=COLOR)

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

async def print_letter(data: PrinterData):
    now = datetime.now()
    future = now + timedelta(days=15)
    
    speed = data.speed
    speed_limit = data.speed_limit
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
    
    texts_positions = [
        ('逕行舉發', (160, 230)),
        ('附採證照片', (160, 260)),
        ('限速    公里，經測時速    公里，', (640, 398)),
        ('超速    公里，', (640, 430)),
        ('本單可至郵局或超商門市繳納罰緩', (585, 228)),
        ('40       0       0', (788, 475)),
        (data.name, (908, 315)),
        (data.plate_number, (160, 315)),
        (data.address, (274, 358)),
        (data.vio_year, (160, 398)),
        (data.vio_month, (250, 398)),
        (data.vio_day, (324, 398)),
        (data.vio_hour, (400, 398)),
        (data.vio_minute, (480, 398)),
        (data.location, (160, 432)),
        (str(future.year - 1911), (210, 466)),
        (future.strftime('%m'), (320, 466)),
        (future.strftime('%d'), (424, 466)),
        (str(now.year - 1911), (240, 750)),
        (now.strftime('%m'), (340, 750)),
        (now.strftime('%d'), (430, 750)),
        (range_text, (824, 430)),
        (str(data.speed_limit), (705, 398)),
        (str(data.speed), (940, 398)),
        (str(speed_diff), (705, 430)),
    ]
    
    image = Image.open(BASE_IMG)
    draw = ImageDraw.Draw(image)
    font = ImageFont.truetype(FONT_PATH, FONT_SIZE, encoding='unic')
    
    draw_texts(draw, font, texts_positions)
    
    # Load attach image from base64 string
    # missing_padding = len(data.photo) % 4
    # if missing_padding:
    #     data.photo += '=' * (4 - missing_padding)
    # attached_image_data = base64.b64decode(data.photo)
    # attached_image = Image.open(io.BytesIO(attached_image_data))
    # image = extend_image(image, attached_image)
    
    # image to base64 string
    image = image.convert('RGB')
    image_bytes = io.BytesIO()
    image.save(image_bytes, format='PNG', optimize=True)
    image_bytes.seek(0)
    return base64.b64encode(image_bytes.getvalue()).decode('utf-8')

