import apiClient from "./api";

// 獲取所有需要人工辨識的車牌資料
export const getUnrecognizedPlates = () => {
    return apiClient.get("/violation/get_all_unrecognized");
  };
  
// 創建新罰單
export const createNewTicket = (ticketData) => {
  return apiClient.post("/violation/issue", ticketData);
};

// 獲取所有車籍資料
export const getAllDrivers = () => {
  return apiClient.get("/vehicle/get");
};
