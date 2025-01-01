import apiClient from "./api";

// 獲取所有未辨識的車牌
export const getUnrecognizedPlates = () => {
  return apiClient.get("/get_unrecognized_license_plates_by_AI");
};

// 更新人工辨識後的車牌
export const updateRecognizedPlate = (violationId, newLicensePlate) => {
  return apiClient.post("/articial_recognize_license_plate", {
    violation_id: violationId,
    new_license_plate: newLicensePlate,
  });
};
