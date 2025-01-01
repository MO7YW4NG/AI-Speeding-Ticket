import axios from "axios";

const apiClient = axios.create({
  baseURL: "http://localhost:8000", // 後端 API 的基礎 URL
  headers: {
    "Content-Type": "application/json",
  },
  timeout: 10000, // 請求超時時間（10秒）
});

export default apiClient;

