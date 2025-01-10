from geojson import Point, Feature, FeatureCollection, MultiPolygon
import json
import be

violation_mapping = {
    0: '可開單', 
    11: '多車牌',
    12: '辨識失敗', 
    21: '圖片模糊',
    22: '車牌遮擋',  
    23: '多車牌',
    24: '車牌合格、車主死亡', 
    25: '車牌不合格', 
    30: '已處理案件 (已開單)',
}

async def update_trafficviolation_today_geojson():
    violations = be.get_today_violations()
    
    features = []
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
                "status_code": violation_mapping.get(violation[10]),
                "district": violation[11],
                "address": violation[12]
            }
        )
        
        features.append(feature)

    geojson_data = FeatureCollection(features)

    with open('/opt/Dashboard-FE/public/mapData/trafficviolation_today.geojson', 'w', encoding='utf-8') as f:
        json.dump(geojson_data, f, ensure_ascii=False, indent=2)    
    
    # print("Generated successfully", geojson_data)
    return geojson_data

async def update_trafficviolation_geojson():
    violations = be.get_all_violations()
    
    features = []
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
                "status_code": violation_mapping.get(violation[10]),
                "district": violation[11],
                "address": violation[12]
            }
        )
        
        features.append(feature)

        geojson_data = FeatureCollection(features)

    with open('/opt/Dashboard-FE/public/mapData/trafficviolation.geojson', 'w', encoding='utf-8') as f:
        json.dump(geojson_data, f, ensure_ascii=False, indent=2)    
    
    # print("Generated successfully", geojson_data)
    return geojson_data

async def update_trafficviolation_polygon_geojson():
    # Read the existing GeoJSON file
    with open('/opt/Dashboard-FE/public/mapData/trafficviolation_polygon.geojson', 'r', encoding='utf-8') as f:
        geojson_data = json.load(f)
    
    # Fetch the updated district violation count
    violations = be.get_district_violation_count()
    violation_dict = {v['district']: v['number'] for v in violations[0][0]}  # Assuming the result is a list of dictionaries
    print ("Violation dict:", violation_dict)
    # Update the number property in the properties of each feature
    for feature in geojson_data['features']:
        district = feature['properties']['location']
        if district in violation_dict:
            feature['properties']['number'] = violation_dict[district]

    # Write the updated GeoJSON back to the file
    with open('/opt/Dashboard-FE/public/mapData/trafficviolation_polygon.geojson', 'w', encoding='utf-8') as f:
        json.dump(geojson_data, f, ensure_ascii=False, indent=2)
    
    print("Updated successfully", geojson_data)
    return geojson_data

async def update_abandoned_trafficviolation_geojson():
    violations = be.get_abandoned_violations()
    
    features = []
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
                "status_code": violation_mapping.get(violation[10]),
                "district": violation[11],
                "address": violation[12]
            }
        )
        
        features.append(feature)

    geojson_data = FeatureCollection(features)

    with open('/opt/Dashboard-FE/public/mapData/trafficviolation_abandoned.geojson', 'w', encoding='utf-8') as f:
        json.dump(geojson_data, f, ensure_ascii=False, indent=2)    
    
    # print("Generated successfully", geojson_data)
    return geojson_data

async def update_sus_licenseplate_geojson():
    violations = be.get_sus_licenseplates()
    
    features = []
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
                "status_code": violation_mapping.get(violation[10]),
                "district": violation[11],
                "address": violation[12]
            }
        )
        
        features.append(feature)

    geojson_data = FeatureCollection(features)

    with open('/opt/Dashboard-FE/public/mapData/trafficviolation_sus_licenseplates.geojson', 'w', encoding='utf-8') as f:
        json.dump(geojson_data, f, ensure_ascii=False, indent=2)    
    
    # print("Generated successfully", geojson_data)
    return geojson_data
