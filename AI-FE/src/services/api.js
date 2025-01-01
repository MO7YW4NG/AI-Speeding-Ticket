import axios from "axios";

const apiClient = axios.create({
  baseURL: "http://localhost:8000", // FastAPI 的基礎 URL
  headers: {
    "Content-Type": "application/json",
  },
});

export default apiClient;
