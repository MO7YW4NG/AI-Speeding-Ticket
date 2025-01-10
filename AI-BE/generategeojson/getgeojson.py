from geojson import Point, Feature, FeatureCollection, dump
import json
import be

async def get_today_violations_geojson():
    violations = be.get_today_violations()
    
    geojson_data = []
    for violation in violations:
        # Create a Point geometry using the coordinates (assumed to be at index 13 and 14)
        point = Point((violation[13], violation[14]))
        
        # Create a Feature using the point and properties
        feature = Feature(
            geometry=point,
            properties={
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
        )
        
        geojson_data.append(feature)

    with open('/opt/Dashboard-FE/public/mapData/trafficviolation_today.geojson', 'w', encoding='utf-8') as f:
        json.dump(geojson_data, f, ensure_ascii=False, indent=4)    
    
    print("Generated successfully", geojson_data)
    return geojson_data