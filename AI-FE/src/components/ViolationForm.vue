<template>
    <div class="flex h-screen w-screen relative">
      <!-- 預覽罰單模態視窗 -->
      <div
        v-if="showPreview"
        class="absolute top-0 left-0 w-full h-full bg-gray-900 bg-opacity-80 flex justify-center items-center z-50"
      >
        <div class="bg-white p-4 rounded-lg shadow-lg w-3/4 h-3/4 flex flex-col">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-semibold">罰單預覽</h3>
            <button @click="closePreview" class="text-red-500 hover:text-red-700 font-bold">關閉</button>
          </div>
          <div class="flex-1 overflow-auto">
            <img src="/assets/Jufa_tongzhidan.jpg" alt="罰單預覽" class="w-full h-full object-contain" />
          </div>
        </div>
      </div>
  
      <!-- 左半邊圖片區域 -->
      <div class="flex-1 bg-gray-800 rounded-lg border border-gray-700 p-4 m-4">
        <div v-if="images.length > 0" class="image-container rounded-lg border border-gray-600">
          <img
            :src="`data:image/jpeg;base64,${images[currentImageIndex]}`"
            :alt="'車牌照片' + (currentImageIndex + 1)"
            class="w-full h-full object-contain"
          />
        </div>
        <div v-else>
          <p class="text-white">無法載入圖片</p>
        </div>
      </div>
  
      <!-- 右半邊表單區域 -->
      <div class="flex-1 bg-gray-800 rounded-lg border border-gray-700 p-4 m-4">
        <h2 class="text-xl text-gray-100 font-semibold mb-4">違規開單系統</h2>
        <div class="flex flex-col space-y-4">
          <!-- 日期 -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">日期</label>
            <input
              type="date"
              v-model="formData.replyDate"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 時間 -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">時間</label>
            <input
              type="time"
              v-model="formData.replyTime"
              step="1"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 員工 ID -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">員工 ID</label>
            <input
              type="text"
              v-model="formData.employeeId"
              readonly
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 處理單位位置 -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">處理單位位置 (IP)</label>
            <input
              type="text"
              v-model="formData.processorIp"
              readonly
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 舉發 ID -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">舉發 ID</label>
            <input
              type="text"
              v-model="formData.serialNumber"
              readonly
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 車牌號碼 -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">車牌號碼</label>
            <input
              type="text"
              v-model="formData.licensePlate"
              readonly
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 違規原因 -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">違規原因</label>
            <textarea
              v-model="formData.violationReason"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
              rows="3"
            ></textarea>
          </div>
  
          <!-- 按鈕 -->
          <div class="flex space-x-4">
            <button
              @click="previewTicket"
              class="flex-1 px-3 py-2 bg-yellow-600 hover:bg-yellow-700 text-white rounded-lg"
            >
              預覽罰單
            </button>
            <button
              @click="resetForm"
              class="flex-1 px-3 py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-lg"
            >
              重置
            </button>
            <button
              @click="submitTicket"
              class="flex-1 px-3 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg"
            >
              提交罰單
            </button>
          </div>
  
          <!-- 切換圖片按鈕 -->
          <div class="flex justify-center mt-4">
            <button
              @click="prevImage"
              class="w-16 h-16 bg-gray-600 hover:bg-gray-700 text-white rounded-full flex items-center justify-center mx-4"
            >
              <i class="fas fa-chevron-left text-2xl"></i>
            </button>
            <button
              @click="nextImage"
              class="w-16 h-16 bg-gray-600 hover:bg-gray-700 text-white rounded-full flex items-center justify-center mx-4"
            >
              <i class="fas fa-chevron-right text-2xl"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import { reactive, ref, onMounted } from "vue";
  import { getAllIssuableViolations } from "@/services/violationService";
  
  export default {
    setup() {
      const formData = reactive({
        serialNumber: "",
        licensePlate: "",
        replyDate: "",
        replyTime: "",
        violationReason: "預設違規原因",
        employeeId: "EMP001", // 預設員工 ID
        processorIp: "192.168.0.1", // 預設處理單位位置 (IP)
      });
  
      const images = ref([]);
      const currentTime = ref("");
      const currentImageIndex = ref(0);
      const issuableViolations = ref([]);
      const showPreview = ref(false);
  
      const fetchIssuableViolations = async () => {
        try {
          const response = await getAllIssuableViolations(formData.employeeId, formData.processorIp);
          issuableViolations.value = response.data.map((entry) => ({
            id: entry[0],
            licensePlate: entry[6],
            image: entry[10],
            reason: entry[11],
          }));
  
          images.value = issuableViolations.value.map((violation) => violation.image);
  
          if (issuableViolations.value.length > 0) {
            currentImageIndex.value = 0;
            populateForm();
          }
        } catch (error) {
          console.error("獲取可開單資料失敗：", error);
        }
      };
  
      const populateForm = () => {
        if (issuableViolations.value[currentImageIndex.value]) {
          const violation = issuableViolations.value[currentImageIndex.value];
          formData.serialNumber = violation.id;
          formData.licensePlate = violation.licensePlate;
          formData.violationReason = violation.reason || "預設違規原因";
        
        }
      };

      const updateTime = () => {
      // 1) 顯示在畫面的 currentTime，如 2025/01/10 11:55:32
      currentTime.value = new Date().toLocaleString();

      // 2) 分別更新 replyDate、replyTime
      const now = new Date();
      formData.replyDate = now.toISOString().split("T")[0]; // "YYYY-MM-DD"
      formData.replyTime = now.toTimeString().split(" ")[0]; // "HH:MM:SS"
    };
  
      const nextImage = () => {
        if (currentImageIndex.value < images.value.length - 1) {
          currentImageIndex.value++;
        } else {
          currentImageIndex.value = 0;
        }
        populateForm();
      };
  
      const prevImage = () => {
        if (currentImageIndex.value > 0) {
          currentImageIndex.value--;
        } else {
          currentImageIndex.value = images.value.length - 1;
        }
        populateForm();
      };
  
      const resetForm = () => {
        formData.serialNumber = "";
        formData.licensePlate = "";
        formData.replyDate = "";
        formData.replyTime = "";
        formData.violationReason = "預設違規原因";
      };
  
      const previewTicket = () => {
        showPreview.value = true;
      };
  
      const closePreview = () => {
        showPreview.value = false;
      };
  
      const submitTicket = async () => {
        alert("提交成功");
      };
  
      onMounted(() => {
        fetchIssuableViolations();
        // 一開始就更新一次
      updateTime();
      // 每秒更新一次
      setInterval(updateTime, 1000);
        
      });
  
      return {
        formData,
        images,
        currentImageIndex,
        nextImage,
        prevImage,
        resetForm,
        previewTicket,
        closePreview,
        showPreview,
        submitTicket,
      };
    },
  };
  </script>
  
  <style scoped>
  .image-container {
    height: 80vh;
  }
  </style>
  