import apiClient from "./api";

// 獲取所有可開單的違規數據
export const getAllIssuableViolations = () => {
  return apiClient.get("/get_all_issuable_violations");
};

// 創建新的罰單
export const createNewTicket = (ticketData) => {
  return apiClient.post("/new_ticket", ticketData);
};
