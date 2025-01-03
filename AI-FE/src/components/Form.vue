<template>
    <div class="flex-1 bg-gray-800 rounded-lg border border-gray-700 p-4 m-4">
      <h2 class="text-xl text-gray-100 font-semibold mb-4">人工辨識紀錄</h2>
      <div class="p-4">
        <div class="flex flex-col space-y-2">
          <!-- AI辨識錯誤的原因 -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">AI辨識錯誤的原因</label>
            <input
              type="text"
              v-model="formData.aiErrorReason"
              readonly
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 辨識車牌號碼 -->
          <div class="flex flex-col mb-4">
            <label class="text-md text-gray-400 mb-1">辨識車牌號碼</label>
            <input
              type="text"
              v-model="formData.licensePlate"
              placeholder="請輸入車牌號碼"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 事件類型 -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">事件類型</label>
            <select
              v-model="formData.eventType"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            >
              <option value="超速">超速</option>
              <option value="違規停車">違規停車</option>
              <option value="闖紅燈">闖紅燈</option>
            </select>
          </div>
  
          <!-- 時間 (系統時間) -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">時間</label>
            <input
              type="text"
              v-model="currentTime"
              readonly
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 舉發ID -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">舉發ID</label>
            <input
              type="text"
              v-model="formData.serialNumber"
              readonly
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 處理機IP位置 -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">處理機IP位置</label>
            <input
              type="text"
              v-model="formData.ip"
              readonly
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 員工ID -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">員工ID</label>
            <input
              type="text"
              v-model="formData.employeeId"
              readonly
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
        </div>
  
        <div class="flex mt-4 space-x-4">
          <!-- 回報區域 -->
          <div class="flex-1 bg-gray-800 rounded-lg p-4 border border-gray-700">
            <h3 class="text-md text-gray-100 font-semibold mb-2">回報原因</h3>
            <div>
              <select
                v-model="formData.reportReason"
                class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md mb-2"
              >
                <option value="無">無</option>
                <option value="圖片模糊">圖片模糊</option>
                <option value="車牌遮擋">車牌遮擋</option>
              </select>
            </div>
            <button @click="submitReport" class="w-full px-3 py-2 mt-4 rounded bg-red-600 hover:bg-red-700 text-white">
              確認回報
            </button>
          </div>
  
          <!-- 提交區域 -->
          <div class="flex-1 flex flex-col justify-between bg-gray-800 rounded-lg p-4">
            <div class="mt-8">
              <button @click="resetForm" class="w-full px-3 py-2 mb-2 rounded bg-gray-600 hover:bg-gray-700 text-white">
                重置
              </button>
            </div>
            <div class="mt-4">
              <button @click="submitForm" class="w-full px-3 py-2 rounded bg-blue-600 hover:bg-blue-700 text-white">
                提交
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import { reactive, ref, onMounted } from "vue";
  import { getUnrecognizedPlates, updateRecognizedPlate } from "@/services/recognitionService";
  
  export default {
    setup() {
      const formData = reactive({
        aiErrorReason: "無法辨識車牌", // AI 辨識錯誤原因
        licensePlate: "", // 用戶輸入的車牌號
        eventType: "超速", // 預設事件類型
        serialNumber: "12345678", // 舉發 ID
        ip: "192.168.0.1", // 處理機 IP
        employeeId: "EMP001", // 員工 ID
        reportReason: "", // 回報原因
      });
  
      const currentTime = ref("");
  
      const updateTime = () => {
        const now = new Date();
        currentTime.value = now.toLocaleString();
      };
  
      // 獲取需要人工辨識的車牌
      const fetchUnrecognizedPlates = async () => {
        try {
          const response = await getUnrecognizedPlates();
          // 根據第一條需要辨識的車牌數據初始化表單
          if (response.data.length > 0) {
            const firstPlate = response.data[0];
            formData.aiErrorReason = firstPlate.aiErrorReason || "無";
            formData.licensePlate = firstPlate.licensePlate || "";
            formData.serialNumber = firstPlate.violationId;
          }
        } catch (error) {
          console.error("獲取需要辨識的車牌失敗:", error);
        }
      };
  
      // 提交表單，更新車牌信息
      const submitForm = async () => {
        try {
          if (!formData.licensePlate) {
            alert("請輸入車牌號碼！");
            return;
          }
          await updateRecognizedPlate(formData.serialNumber, formData.licensePlate);
          alert("表單提交成功！");
          fetchUnrecognizedPlates(); // 提交後重新獲取需要辨識的車牌
        } catch (error) {
          console.error("表單提交失敗:", error);
          alert("表單提交失敗，請稍後再試！");
        }
      };
  
      const resetForm = () => {
        formData.licensePlate = "";
        formData.eventType = "超速";
        formData.reportReason = "";
      };
  
      const submitReport = () => {
        console.log("回報原因:", formData.reportReason);
        alert("回報提交成功！");
      };
  
      onMounted(() => {
        updateTime();
        setInterval(updateTime, 1000);
        fetchUnrecognizedPlates(); // 組件掛載時獲取需要辨識的車牌
      });
  
      return {
        formData,
        currentTime,
        resetForm,
        submitForm,
        submitReport,
      };
    },
  };
  </script>
  