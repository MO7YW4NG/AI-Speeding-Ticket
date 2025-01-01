import apiClient from "./api";

// 獲取所有需要被辨識的車牌
export const getUnrecognizedPlates = () => {
  return apiClient.get("/violation/get_all_unrecognized");
};

// 更新人工辨識的車牌信息
export const updateRecognizedPlate = (violationId, newLicensePlate) => {
  return apiClient.post("/violation/update", {
    violation_id: violationId,
    new_license_plate: newLicensePlate,
  });
};
