import geojson
import be

async def get_today_violations_geojson():
    violations = be.get_today_violations()
    
    features = []
    for violation in violations:
        feature = {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [violation[13], violation[14]]  # Assuming geom is the last column
            },
            "properties": {
                "violation_id": violation[0],
                "violation_date": violation[1].isoformat(),
                "violation_time": violation[2].strftime("%H:%M:%S"),
                "device_id": violation[3],
                "speed_limit": violation[4],
                "vehicle_speed": violation[5],
                "license_plate": violation[6],
                "licenseplate_reply_date": violation[7].isoformat(),
                "licenseplate_reply_time": violation[8].strftime("%H:%M:%S"),
                "vehicle_type": violation[9],
                "status_code": violation[10],
                "district": violation[11],
                "address": violation[12]
            }
        }
        features.append(feature)
    
    feature_collection = {
        "type": "FeatureCollection",
        "features": features
    }
    
    print("Generated successfully", feature_collection)
    return feature_collection