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
  
          <!-- 時間 -->
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
  
          <!-- 處理單位位置 (IP) -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">處理單位位置</label>
            <input
              type="text"
              v-model="formData.ipLocation"
              placeholder="192.168.0.1"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 員工ID -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">員工ID</label>
            <input
              type="text"
              v-model="formData.employeeId"
              placeholder="EMP001"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 底部區域 -->
          <div class="flex justify-between mt-6">
            <!-- 回報原因區塊 -->
            <div class="flex-1 pr-4">
              <label class="text-md text-gray-400 mb-2 block">回報原因</label>
              <select
                v-model="formData.reportReason"
                class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
              >
                <option value="錯誤">錯誤</option>
                <option value="其他">其他</option>
              </select>
              <button
                @click="confirmReport"
                class="w-full mt-4 px-3 py-2 bg-red-600 hover:bg-red-700 text-white rounded-md"
              >
                確認回報
              </button>
            </div>
  
            <!-- 按鈕區域 -->
            <div class="flex-1 pl-4">
              <button
                @click="resetForm"
                class="w-full mt-8 mb-4 px-3 py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-md"
              >
                重置
              </button>
              <button
                @click="submitForm"
                class="w-full px-3 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md"
              >
                提交
              </button>
            </div>
       
          </div>
          
        </div>
            
      </div>
           <!-- 切換圖片按鈕 -->
    <div class="flex justify-center mt-8">
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
  </template>
  
  <script>
  import { reactive, ref, computed, onMounted } from "vue";
  import { getUnrecognizedPlates, updateRecognizedPlate } from "@/services/recognitionService";
  import eventBus from "@/components/eventBus"; // 引入事件總線

  export default {
    setup() {
      // 表單數據
      const formData = reactive({
        aiErrorReason: "無法辨識車牌",
        licensePlate: "",
        eventType: "超速",
        serialNumber: "",
        ipLocation: "192.168.0.1",
        employeeId: "EMP001",
        reportReason: "錯誤",
      });

      // 時間和圖片數據
      const currentTime = ref("");
      const images = ref([]);
      const plates = ref([]);
      const currentImageIndex = eventBus.currentImageIndex; // 使用事件總線的共享索引

      // 更新時間
      const updateTime = () => {
        const now = new Date();
        currentTime.value = now.toLocaleString();
      };

      // 加載數據
      const fetchUnrecognizedPlates = async () => {
        try {
          const response = await getUnrecognizedPlates();
          plates.value = response.data;
          images.value = plates.value.map((plate) => plate.image);
          if (plates.value.length > 0) updateFormData(currentImageIndex.value); // 初始化表單
        } catch (error) {
          console.error("獲取需要辨識的車牌失敗:", error);
        }
      };

      // 更新表單數據
      const updateFormData = (index) => {
        const plate = plates.value[index];
        formData.aiErrorReason = plate?.aiErrorReason || "無";
        formData.licensePlate = plate?.licensePlate || "";
        formData.serialNumber = plate?.violationId || "";
      };

      // 表單重置
      const resetForm = () => {
        formData.licensePlate = "";
        formData.eventType = "超速";
        formData.ipLocation = "192.168.0.1";
        formData.employeeId = "EMP001";
        formData.reportReason = "錯誤";
      };

      // 提交表單
      const submitForm = async () => {
        try {
          if (!formData.licensePlate) {
            alert("請輸入車牌號碼！");
            return;
          }
          await updateRecognizedPlate(formData.serialNumber, formData.licensePlate);
          alert("表單提交成功！");
          fetchUnrecognizedPlates();
        } catch (error) {
          console.error("表單提交失敗:", error);
          alert("表單提交失敗，請稍後再試！");
        }
      };

      // 切換到下一張圖片
      const nextImage = () => {
        eventBus.nextImage(images.value.length); // 通過事件總線切換索引
        updateFormData(currentImageIndex.value); // 更新表單
      };

      // 切換到上一張圖片
      const prevImage = () => {
        eventBus.prevImage(images.value.length); // 通過事件總線切換索引
        updateFormData(currentImageIndex.value); // 更新表單
      };

      // 組件掛載時初始化數據
      onMounted(() => {
        updateTime();
        setInterval(updateTime, 1000);
        fetchUnrecognizedPlates();
      });

      return {
        formData,
        currentTime,
        images,
        resetForm,
        submitForm,
        nextImage,
        prevImage,
        currentImage: computed(() => images.value[currentImageIndex.value]), // 動態計算當前圖片
      };
    },
  };
</script>

