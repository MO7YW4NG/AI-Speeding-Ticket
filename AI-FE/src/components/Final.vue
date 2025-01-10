<template>
    <div class="flex flex-col h-screen w-screen bg-gray-800 text-white">
      <!-- 大標題 -->
      <h1 class="text-3xl font-bold mb-6 text-center py-4">AI 辨識子系統辨識</h1>
  
      <!-- 按鈕 -->
      <div class="flex justify-center mb-4">
        <button
          @click="fetchViolations"
          class="bg-blue-600 hover:bg-blue-700 px-6 py-2 rounded-md text-sm"
        >
          獲取前四筆資料
        </button>
      </div>
  
      <!-- 表格 -->
      <div class="flex-1 overflow-auto px-8">
        <table class="table-auto w-full border-collapse border border-gray-700 text-center">
          <thead class="bg-gray-900">
            <tr>
              <th class="border border-gray-700 px-4 py-2">Photo</th>
              <th class="border border-gray-700 px-4 py-2">Address</th>
              <th class="border border-gray-700 px-4 py-2">Violation Date</th>
              <th class="border border-gray-700 px-4 py-2">Violation Time</th>
              <th class="border border-gray-700 px-4 py-2">Device ID</th>
              <th class="border border-gray-700 px-4 py-2">Speed Limit</th>
              <th class="border border-gray-700 px-4 py-2">Vehicle Speed</th>
              <th class="border border-gray-700 px-4 py-2">Longitude</th>
              <th class="border border-gray-700 px-4 py-2">Latitude</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(violation, index) in topViolations" :key="index" class="hover:bg-gray-700">
              <td class="border border-gray-700 px-4 py-2">
                <img
                  :src="'data:image/jpeg;base64,' + violation.photo"
                  alt="Violation Photo"
                  class="w-16 h-16 object-contain"
                />
              </td>
              <td class="border border-gray-700 px-4 py-2">{{ violation.address }}</td>
              <td class="border border-gray-700 px-4 py-2">{{ violation.violation_date }}</td>
              <td class="border border-gray-700 px-4 py-2">{{ violation.violation_time }}</td>
              <td class="border border-gray-700 px-4 py-2">{{ violation.device_id }}</td>
              <td class="border border-gray-700 px-4 py-2">{{ violation.speed_limit }}</td>
              <td class="border border-gray-700 px-4 py-2">{{ violation.vehicle_speed }}</td>
              <td class="border border-gray-700 px-4 py-2">{{ violation.longitude }}</td>
              <td class="border border-gray-700 px-4 py-2">{{ violation.latitude }}</td>
            </tr>
          </tbody>
        </table>
      </div>
  
      <!-- 下方照片 -->
      <div class="grid grid-cols-4 gap-4 px-8 py-4">
        <div
          v-for="(violation, index) in topViolations"
          :key="index"
          class="border border-gray-700 rounded-lg p-2"
        >
          <img
            :src="'data:image/jpeg;base64,' + violation.photo"
            alt="Violation Photo"
            class="w-full h-40 object-cover rounded-md"
          />
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import axios from "axios";
  
  export default {
    data() {
      return {
        violations: [], // 保存 API 返回的全部資料
        topViolations: [], // 提取前四筆資料
      };
    },
    methods: {
        async fetchViolations() {
  try {
    const response = await axios.get("http://localhost:8000/violation/get_all_unrecognized", {
      params: { employee_id: "EMP001", processor_ip: "192.168.0.1" },
    });
    console.log("API 回傳的資料：", response.data); // 確認 API 回傳的資料
    this.violations = response.data;
    this.topViolations = this.violations.slice(0, 4); // 提取前四筆資料
    console.log("提取的前四筆資料：", this.topViolations); // 確認提取的資料
  } catch (error) {
    console.error("獲取違規資料失敗：", error); // 確認錯誤訊息
  }
}
},
    mounted() {
      this.fetchViolations(); // 頁面加載時自動調用
    },
  };
  </script>
  
  <style scoped>
  .table-auto th,
  .table-auto td {
    white-space: nowrap;
  }
  </style>
  