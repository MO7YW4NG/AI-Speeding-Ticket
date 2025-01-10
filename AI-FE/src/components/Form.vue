<template>

<div class="flex-1 bg-gray-800 rounded-lg border border-gray-700 p-4 m-4">
        <div v-if="images.length > 0" class="image-container rounded-lg border border-gray-600">
          <img
            :src="`data:image/jpeg;base64,${images[currentImageIndex]}`"
            :alt="'車牌照片' + (currentImageIndex + 1)"
            class="w-full h-full object-contain"
          />
        </div>
        <div v-else class="flex items-center justify-center h-full">
  <p class="text-white text-2xl font-semibold">現已沒有需要辨識的照片</p>
</div>
      </div>
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
  
          <!-- 辨識車牌號碼 (更改欄位) -->
          <div class="flex flex-col mb-4">
            <label class="text-md text-gray-400 mb-1">辨識車牌號碼(更改欄位)</label>
            <input
              type="text"
              v-model="formData.licensePlate"
              id="license-plate"
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
  
           <!-- 回傳日期 (ex: 2025-01-10) -->
        <div class="flex flex-col">
          <label class="text-md text-gray-400 mb-1">日期</label>
          <input
            type="date"
            v-model="formData.replyDate"
            class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
          />
        </div>

        <!-- 回傳時間 (ex: 10:00:00) -->
        <div class="flex flex-col">
          <label class="text-md text-gray-400 mb-1">時間</label>
          <input
            type="time"
            v-model="formData.replyTime"
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
  
           <!-- 底部區域：回報原因 (左) + 按鈕 (右) -->
        <div class="flex justify-between mt-6">
          <!-- 回報原因區塊 -->
          <div class="flex-1 pr-4">
            <label class="text-md text-gray-400 mb-2 block">
              回報原因 (影響 respond_code)
            </label>
            <select
              v-model="formData.respondCode"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            >
              <!-- 0=可辨識,1=圖片模糊,2=遮擋,3=多車牌 -->
              <option value="0">可辨識(更新車牌)</option>
              <option value="1">圖片模糊</option>
              <option value="2">車牌遮擋</option>
              <option value="3">多車牌</option>
            </select>
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
import { getAllUnrecognizedViolations, updateStatus } from "@/services/recognitionService";

export default {
  setup() {
    // 1. 表單數據
    const formData = reactive({
      aiErrorReason: "無法辨識車牌",
      licensePlate: "",
      eventType: "超速",
      serialNumber: "",
      ipLocation: "192.168.0.1",
      employeeId: "EMP001",
      // 新增: 分開存放回傳日期 & 時間
      replyDate: "",
      replyTime: "",
      respondCode: 0, // 0=可辨識, 1=圖片模糊, 2=車牌遮擋, 3=多車牌
    });

    // 時間 & 圖片
    const currentTime = ref("");
    const plates = ref([]);
    const images = ref([]);
    const Unrecognized = ref([]);
    const currentImageIndex = ref(0);

    const updateTime = () => {
      // 1) 顯示在畫面的 currentTime，如 2025/01/10 11:55:32
      currentTime.value = new Date().toLocaleString();

      // 2) 分別更新 replyDate、replyTime
      const now = new Date();
      formData.replyDate = now.toISOString().split("T")[0]; // "YYYY-MM-DD"
      formData.replyTime = now.toTimeString().split(" ")[0]; // "HH:MM:SS"
    };
    const fetchUnrecognizedPlates = async () => {
  try {
    const response = await getAllUnrecognizedViolations(formData.employeeId, formData.processorIp);
    console.log("後端返回的數據:", response.data);

    Unrecognized.value = response.data.map((entry) => ({
      id: entry[0],
      licensePlate: entry[6],
      image: entry[10],
      reason: entry[11],
    }));

    images.value = Unrecognized.value.map((violation) => violation.image);

    if (Unrecognized.value.length > 0) {
      currentImageIndex.value = 0;
      populateForm();
    } else {
      alert("未找到需要人工辨識的數據！");
    }
  } catch (error) {
    console.error("獲取可開單資料失敗：", error.response || error.message);
  }
};


  
const populateForm = () => {
  if (Unrecognized.value[currentImageIndex.value]) {
    const violation = Unrecognized.value[currentImageIndex.value];
    formData.serialNumber = violation.id || "";
    formData.licensePlate = violation.licensePlate || "";
    formData.aiErrorReason = violation.reason === 11
      ? "多車牌"
      : violation.reason === 12
      ? "其他原因"
      : "無法辨識車牌";
  } else {
    resetForm(); // 若無數據，清空表單
  }
};


    // 3. 更新表單
    const updateFormData = (index) => {
      if (!plates.value.length) {
        resetForm();
        return;
      }
      const plate = plates.value[index];

      // plate[0] => violation_id, plate[6] => license_plate, plate[11] => status_code
      formData.serialNumber = plate[0] || "";
      formData.licensePlate = plate[6] || "";

      // AI辨識錯誤原因
      if (plate[11] === 11) {
        formData.aiErrorReason = "多車牌";
      } else if (plate[11] === 12) {
        formData.aiErrorReason = "其他原因";
      } else {
        formData.aiErrorReason = "無法辨識車牌";
      }

     
    };

    // 4. 重置表單
    const resetForm = () => {
      formData.aiErrorReason = "無法辨識車牌";
      formData.licensePlate = "";
      formData.eventType = "超速";
      formData.serialNumber = "";
      formData.ipLocation = "192.168.0.1";
      formData.employeeId = "EMP001";
      // 重要：也重置日期與時間
      formData.replyDate = "";
      formData.replyTime = "";
      formData.respondCode = 0;
    };

    // 5. 提交表單 => 調用 updateStatus
    const submitForm = async () => {
      try {
        if (!formData.serialNumber) {
          alert("舉發ID不存在，無法提交！");
          return;
        }
        // respondCode=0 => 可辨識(更新車牌), 1/2/3 => 不更新車牌, 只記錄
        if (formData.respondCode === 0 && !formData.licensePlate) {
          alert("請輸入可辨識的車牌號碼！");
          return;
        }

     

        const payload = {
          new_license_plate: formData.licensePlate,
          employee_id: formData.employeeId,
          processor_ip: formData.ipLocation,
          respond_code: Number(formData.respondCode),
          // 新增：帶上回傳日期 / 時間
          reply_date: formData.replyDate,
          reply_time: formData.replyTime,
        };

         // 如果 respondCode 是 1/2/3，更新 status_code 為 21
    if ([1, 2, 3].includes(formData.respondCode)) {
      payload.status_code = 21; // 在 Payload 中新增 status_code
    }

        await updateStatus(formData.serialNumber, payload);
        alert("表單提交成功！");
        fetchUnrecognizedPlates(); // 重新載入
        location.reload();
      } catch (error) {
        console.error("表單提交失敗:", error);
        alert("表單提交失敗，請稍後再試！");
      }
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

     // 掛載時
     onMounted(() => {
      // 一開始就更新一次
      updateTime();
      // 每秒更新一次
      setInterval(updateTime, 1000);

      // 拿後端資料
      fetchUnrecognizedPlates();
    });

    // 計算當前圖片(若要顯示預覽)
    const currentImage = computed(() => images.value[currentImageIndex.value]);

    return {
      formData,
      currentTime,
      images,
      plates,
      currentImageIndex,
      currentImage,

      resetForm,
      submitForm,
      nextImage,
      prevImage,
      updateFormData,
    };
  },
};
</script>

<style scoped>
  .image-container {
    height: 80vh;
  }
  </style>
