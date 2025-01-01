import apiClient from "./api";

// 獲取所有車籍資料
export const getAllDrivers = () => {
  return apiClient.get("/get_all_driver");
};