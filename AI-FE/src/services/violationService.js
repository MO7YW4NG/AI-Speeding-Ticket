import apiClient from "./api";

// 獲取所有表單資料
export const getViolationForms = () => apiClient.get("/violations/forms");

// 提交新的表單資料
export const createViolationForm = (formData) => apiClient.post("/violations/forms", formData);

// 獲取所有圖片資料
export const getViolationImages = () => apiClient.get("/violations/images");

// 上傳新的圖片資料
export const uploadViolationImage = (imageData) => apiClient.post("/violations/images", imageData);
