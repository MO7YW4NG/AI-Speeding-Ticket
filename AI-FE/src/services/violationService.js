import apiClient from "./api";

// 獲取所有可以開單的資料
export const getAllIssuableViolations = () => {
  return apiClient.get("/violation/get_all");
};

// 創建新罰單
export const createNewTicket = (ticketData) => {
  return apiClient.post("/violation/issue", ticketData);
};

// 獲取所有車籍資料
export const getAllDrivers = () => {
  return apiClient.get("/vehicle/get");
};
