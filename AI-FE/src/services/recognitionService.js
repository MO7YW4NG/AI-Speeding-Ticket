import apiClient from "./api";

// 獲取所有需要人工辨識的車牌資料
export const getUnrecognizedPlates = () => {
  return apiClient.get("/violation/get_all_unrecognized");
};

// 更新車牌號碼
export const updateRecognizedPlate = (violationId, licensePlate) => {
    return apiClient.post(
        `/violation/update_license_plate?violation_id=${violationId}&new_license_plate=${licensePlate}`
      );
    };

    // 更新違規狀態碼
export const updateViolationStatus = (violationId, newStatus) => {
    return apiClient.post("/violation/update_status", {
      violation_id: violationId,
      status_code: newStatus,
    });
  };