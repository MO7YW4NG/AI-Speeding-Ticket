import aiohttp
import json
import asyncio
import time

API_KEY = 'UtdUpYXvolEqgp3y0K3qnHR+r9qIX6gRpG2LH7Cg6SGyDXVXT4qJVRPjX6T54iIFlWgnF3r3TqvBzw1oj+VgQaIlLQGOBdZVs/IKP+gWpxgc2WH6EJNjN1NG3W5CtxDF'
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36 Edg/131.0.0.0",
    "Accept-Encoding": "gzip, deflate, br, zstd",
    "Origin": "https://map.tgos.tw",
    "Referer": "https://map.tgos.tw/",
}

COOLDOWN_PERIOD = 5  # seconds
last_call_time = time.time()

async def get_geocode(address: str) -> tuple[float, float]:
    global last_call_time
    if time.time() - last_call_time < COOLDOWN_PERIOD:
        await asyncio.sleep(COOLDOWN_PERIOD - (time.time() - last_call_time))
    last_call_time = time.time()
    async with aiohttp.ClientSession(headers=HEADERS) as session:
        async with session.get(f'https://api.tgos.tw/MOIMAPService/TGComplexLocate?APIKEY={API_KEY}&input={address}&ignoreGeometry=false&pnum=1') as response:
            response_json = await response.json()
            if not response_json['isSuccess']:
                return (0, 0)
            result = json.loads(response_json['result'])
            geometry = result['results'][0]['geometry']
            return (geometry['x'], geometry['y'])
