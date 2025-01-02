import apiClient from "./api";

// 獲取所有需要人工辨識的車牌資料
export const getUnrecognizedPlates = () => {
  return apiClient.get("/violation/get_all_unrecognized");
};