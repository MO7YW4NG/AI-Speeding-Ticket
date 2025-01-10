from geojson import Point, Feature, FeatureCollection, MultiPolygon
import json
import be

async def update_trafficviolation_today_geojson():
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
        json.dump(geojson_data, f, ensure_ascii=False, indent=2)    
    
    # print("Generated successfully", geojson_data)
    return geojson_data

async def update_trafficviolation_geojson():
    violations = be.get_all_violations()
    
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
        json.dump(geojson_data, f, ensure_ascii=False, indent=2)    
    
    # print("Generated successfully", geojson_data)
    return geojson_data

async def update_trafficviolation_polygon_geojson():
    violations = be.get_district_violation_count()

    features = []
    for violation in violations[0][0]:  # Assuming the result is a list of dictionaries
        # Create a MultiPolygon geometry using the coordinates
        multipolygon = MultiPolygon([violation['coordinates']])
        
        # Create a Feature using the multipolygon and properties
        feature = Feature(
            geometry=multipolygon,
            properties={
                "number": violation['number'],
                "location": violation['district']
            }
        )
        
        features.append(feature)

    feature_collection = FeatureCollection(features)

    # Use the correct path within the Dashboard-FE directory
    with open('/opt/Dashboard-FE/public/mapData/trafficviolation_polygon.geojson', 'w', encoding='utf-8') as f:
        json.dump(feature_collection, f, ensure_ascii=False, indent=2)    
    
    # print("Generated successfully", feature_collection)
    return feature_collection

async def update_abandoned_trafficviolation_geojson():
    violations = be.get_abandoned_violations()
    
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

    with open('/opt/Dashboard-FE/public/mapData/trafficviolation_abandoned.geojson', 'w', encoding='utf-8') as f:
        json.dump(geojson_data, f, ensure_ascii=False, indent=2)    
    
    # print("Generated successfully", geojson_data)
    return geojson_data

async def update_sus_licenseplate_geojson():
    violations = be.get_sus_licenseplates()
    
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

    with open('/opt/Dashboard-FE/public/mapData/trafficviolation_sus_licenseplates.geojson', 'w', encoding='utf-8') as f:
        json.dump(geojson_data, f, ensure_ascii=False, indent=2)    
    
    # print("Generated successfully", geojson_data)
    return geojson_data
