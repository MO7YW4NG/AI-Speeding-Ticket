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
        </div>
  
        <!-- 按鈕區域 -->
        <div class="flex mt-4 space-x-4">
          <!-- 提交區域 -->
          <div class="flex-1 flex flex-col justify-between bg-gray-800 rounded-lg p-4">
            <button @click="prevImage" class="w-full px-3 py-2 rounded bg-gray-600 hover:bg-gray-700 text-white">
              上一圖片
            </button>
            <button @click="submitForm" class="w-full px-3 py-2 rounded bg-blue-600 hover:bg-blue-700 text-white">
              提交
            </button>
            <button @click="nextImage" class="w-full px-3 py-2 rounded bg-gray-600 hover:bg-gray-700 text-white">
              下一圖片
            </button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
 
import { reactive, ref, onMounted } from "vue"; // 引入 Vue 的核心功能
import { getUnrecognizedPlates, updateRecognizedPlate } from "@/services/recognitionService"; // 引入與後端交互的 API 方法

export default {
  setup() {
    // 定義表單數據，並初始化值
    const formData = reactive({
      aiErrorReason: "無法辨識車牌", // AI 無法辨識車牌的原因
      licensePlate: "", // 用戶輸入的車牌號
      eventType: "超速", // 預設事件類型
      serialNumber: "", // 舉發 ID
    });

    // 定義其他響應式數據
    const currentTime = ref(""); // 當前時間，用於顯示系統時間
    const images = ref([]); // 存儲所有圖片（Base64 格式）
    const plates = ref([]); // 存儲所有未辨識的車牌資料
    const currentImageIndex = ref(0); // 當前顯示的圖片索引

    // 更新當前時間的方法，格式化為本地時間字符串
    const updateTime = () => {
      const now = new Date(); // 獲取當前時間
      currentTime.value = now.toLocaleString(); // 將時間格式化為本地字符串
    };

    // 獲取未辨識車牌的數據，並初始化圖片和表單
    const fetchUnrecognizedPlates = async () => {
      try {
        // 調用後端 API 獲取數據
        const response = await getUnrecognizedPlates();
        plates.value = response.data; // 將返回的數據存入 plates
        images.value = plates.value.map((plate) => plate.image); // 提取圖片字段，存入 images
        if (plates.value.length > 0) updateFormData(0); // 如果有數據，初始化表單為第一筆數據
      } catch (error) {
        console.error("獲取需要辨識的車牌失敗:", error); // 如果調用失敗，記錄錯誤
      }
    };

    // 更新表單數據的方法，根據圖片索引切換表單內容
    const updateFormData = (index) => {
      const plate = plates.value[index]; // 根據索引取出對應的車牌數據
      formData.aiErrorReason = plate.aiErrorReason || "無"; // 更新 AI 辨識錯誤原因
      formData.licensePlate = plate.licensePlate || ""; // 更新車牌號碼
      formData.serialNumber = plate.violationId; // 更新舉發 ID
    };

    // 切換到下一圖片的方法
    const nextImage = () => {
      currentImageIndex.value =
        (currentImageIndex.value + 1) % images.value.length; // 計算下一張圖片索引
      updateFormData(currentImageIndex.value); // 更新表單為下一圖片對應的數據
    };

    // 切換到上一圖片的方法
    const prevImage = () => {
      currentImageIndex.value =
        (currentImageIndex.value - 1 + images.value.length) % images.value.length; // 計算上一張圖片索引
      updateFormData(currentImageIndex.value); // 更新表單為上一圖片對應的數據
    };

    // 提交表單的方法，將數據發送到後端
    const submitForm = async () => {
      try {
        if (!formData.licensePlate) {
          alert("請輸入車牌號碼！"); // 如果車牌號碼為空，提示用戶
          return;
        }
        // 調用後端 API 提交數據
        await updateRecognizedPlate(formData.serialNumber, formData.licensePlate);
        alert("表單提交成功！"); // 提示提交成功
        fetchUnrecognizedPlates(); // 重新加載未辨識的車牌數據
      } catch (error) {
        console.error("表單提交失敗:", error); // 如果提交失敗，記錄錯誤
        alert("表單提交失敗，請稍後再試！");
      }
    };

    // Vue 組件掛載時調用的方法
    onMounted(() => {
      updateTime(); // 更新當前時間
      setInterval(updateTime, 1000); // 每秒更新時間一次
      fetchUnrecognizedPlates(); // 加載未辨識的車牌數據
    });

    // 返回數據和方法，供模板中使用
    return {
      formData, // 表單數據
      currentTime, // 當前時間
      images, // 圖片數據
      nextImage, // 下一圖片方法
      prevImage, // 上一圖片方法
      submitForm, // 提交表單方法
    };
  },
};

  </script>