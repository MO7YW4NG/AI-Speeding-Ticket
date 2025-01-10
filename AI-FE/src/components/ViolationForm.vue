<template>
    <div class="flex h-screen w-screen relative">
   <!-- 預覽罰單模態視窗 -->
<div
  v-if="showPreview"
  class="absolute top-0 left-0 w-full h-full bg-gray-900 bg-opacity-90 flex justify-center items-center z-50"
>
  <div class="bg-white bg-opacity-90 p-6 rounded-lg shadow-xl w-3/5 h-4/5 flex flex-col relative">
    <!-- 關閉按鈕 -->
    <button
      @click="closePreview"
      class="absolute top-4 right-4 text-gray-600 hover:text-gray-900 text-2xl font-bold"
    >
      &times;
    </button>

    <!-- 標題 -->
    <h3 class="text-xl font-semibold text-gray-800 text-center mb-4">罰單預覽</h3>

    <!-- 圖片區域 -->
    <div class="flex-1 overflow-auto flex justify-center items-center">
      <img
        v-if="ticketImage"
        :src="`data:image/png;base64,${ticketImage}`"
        alt="罰單預覽"
        class="max-w-full max-h-full object-contain rounded-lg shadow-lg"
      />
      <p v-else class="text-center text-gray-500">正在生成罰單...</p>
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
  
          <!-- 速限 -->
<div class="flex flex-col">
  <label class="text-md text-gray-400 mb-1">速限</label>
  <input
    type="text"
    v-model="formData.speedLimit"
    readonly
    class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
  />
</div>

<!-- 實際車速 -->
<div class="flex flex-col mt-4">
  <label class="text-md text-gray-400 mb-1">實際車速</label>
  <input
    type="text"
    v-model="formData.vehicleSpeed"
    readonly
    class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
  />
</div>
  
          <!-- 按鈕 -->
          <div class="flex space-x-4">
            <button
              @click="previewTicket"
              class="flex-1 mt-5 px-3 py-2 bg-yellow-600 hover:bg-yellow-700 text-white rounded-lg"
            >
              預覽罰單
            </button>
            <button
              @click="resetForm"
              class="flex-1 mt-5  px-3 py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-lg"
            >
              重置
            </button>
            <button
              @click="submitViolation"
              class="flex-1 mt-5  px-3 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg"
            >
              提交罰單
            </button>
          </div>
  
          <!-- 切換圖片按鈕 -->
          <!--<div class="flex justify-center mt-4">
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
          </div> -->
        </div>
      </div>
    </div>
  </template>
  
  <script>
import { reactive, ref, onMounted } from "vue";
import { getAllIssuableViolations, issueNewViolation } from "@/services/violationService";
import axios from "axios";

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
      name: "王小明", // 預設姓名
      address: "台北市中正區XX路XX號", // 預設車主地址
      speedLimit: "", // 新增：速限
      vehicleSpeed: "", // 新增：實際車速
      vio_year: "",
      vio_month: "",
      vio_day: "",
      vio_hour: "",
      vio_minute: "",
      location: "台北市某路口", // 預設違規地址
      speed: 75, // 違規速度
      speed_limit: 50, // 速限
      photo: "", // 違規照片 (Base64)
    });

    const images = ref([]); // 圖片列表
    const currentImageIndex = ref(0);
    const issuableViolations = ref([]); // 可開單的違規項
    const showPreview = ref(false);
    const ticketImage = ref(""); // API 返回的罰單圖片 (Base64)

    // 獲取可開單資料
    const fetchIssuableViolations = async () => {
      try {
        const response = await getAllIssuableViolations(formData.employeeId, formData.processorIp);
        issuableViolations.value = response.data.map((entry) => ({
          id: entry[0],
          licensePlate: entry[6],
          speedLimit: entry[4], // 將 entry[4] 對應速限
          vehicleSpeed: entry[5], // 將 entry[5] 對應實際車速
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

    // 填充表單數據
    const populateForm = () => {
      if (issuableViolations.value[currentImageIndex.value]) {
        const violation = issuableViolations.value[currentImageIndex.value];
        formData.serialNumber = violation.id;
        formData.licensePlate = violation.licensePlate;
        formData.speedLimit = violation.speedLimit;
        formData.vehicleSpeed = violation.vehicleSpeed;
        formData.violationReason = violation.reason || "預設違規原因";
        formData.photo = violation.image; // 將圖片設置到表單中

        // 更新違規時間
        const now = new Date();
        formData.vio_year = now.getFullYear().toString();
        formData.vio_month = (now.getMonth() + 1).toString().padStart(2, "0");
        formData.vio_day = now.getDate().toString().padStart(2, "0");
        formData.vio_hour = now.getHours().toString().padStart(2, "0");
        formData.vio_minute = now.getMinutes().toString().padStart(2, "0");
      }
      else {
    resetForm(); // 如果沒有資料，清空表單
  }
    };

    // 更新時間，每秒更新一次
    const updateTime = () => {
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
      formData.speedLimit = "";
        formData.vehicleSpeed = "";
      formData.violationReason = "預設違規原因";
    };

    const previewTicket = async () => {
      try {
        console.log("準備生成罰單，傳送的數據為：", {
          name: formData.name,
          plate_number: formData.licensePlate,
          address: formData.address,
          vio_year: formData.replyDate.split("-")[0],
          vio_month: formData.replyDate.split("-")[1],
          vio_day: formData.replyDate.split("-")[2],
          vio_hour: formData.replyTime.split(":")[0],
          vio_minute: formData.replyTime.split(":")[1],
          location: formData.location,
          speed: formData.speed,
          speed_limit: formData.speed_limit,
          photo: images.value[currentImageIndex.value],
        });

        const response = await axios.post("http://localhost:8000/print-letter", {
          name: formData.name,
          plate_number: formData.licensePlate,
          address: formData.address,
          vio_year: formData.replyDate.split("-")[0],
          vio_month: formData.replyDate.split("-")[1],
          vio_day: formData.replyDate.split("-")[2],
          vio_hour: formData.replyTime.split(":")[0],
          vio_minute: formData.replyTime.split(":")[1],
          location: formData.location,
          speed: formData.speed,
          speed_limit: formData.speed_limit,
          photo: images.value[currentImageIndex.value],
        });

        ticketImage.value = response.data.image; // API 返回罰單 Base64 字串
        showPreview.value = true;
      } catch (error) {
        console.error("生成罰單失敗，錯誤信息：", error.response?.data || error.message);
        alert("生成罰單失敗，請檢查輸入數據！");
      }
    };

    const closePreview = () => {
      showPreview.value = false;
      ticketImage.value = "";
    };

    async function submitViolation() {
  try {
    const response = await issueNewViolation(formData.serialNumber, formData.employeeId, formData.processorIp);
    console.log("Violation issued successfully:", response.data);

    // 移除當前的資料和圖片
    issuableViolations.value.splice(currentImageIndex.value, 1);
    images.value.splice(currentImageIndex.value, 1);

    // 如果還有剩下的資料，移動到下一筆；否則重置索引
    if (issuableViolations.value.length > 0) {
      if (currentImageIndex.value >= issuableViolations.value.length) {
        currentImageIndex.value = 0; // 如果是最後一筆，重置索引到第一筆
      }
      populateForm(); // 填充下一筆資料
    } else {
      resetForm(); // 如果沒有資料了，清空表單
      alert("所有罰單已處理完畢！");
    }
  } catch (error) {
    console.error("Failed to issue violation:", error.response?.data || error.message);
    alert("提交失敗，請稍後再試！");
  }
}


    onMounted(() => {
      fetchIssuableViolations();
      // 一開始就更新一次
      updateTime();
      // 每秒更新一次
      setInterval(updateTime, 1000);
    });

    return {
        submitViolation,
      formData,
      images,
      currentImageIndex,
      nextImage,
      prevImage,
      resetForm,
      previewTicket,
      closePreview,
      showPreview,
      ticketImage,
    };
  },
};
</script>

  
<style scoped>
/* 讓模態視窗的背景半透明 */
.bg-gray-900 {
  backdrop-filter: blur(6   px); /* 添加背景模糊效果 */
}

/* 關閉按鈕的樣式 */
button.close-btn {
  transition: transform 0.2s ease-in-out;
}

button.close-btn:hover {
  transform: scale(1.2); /* 滑鼠懸停時放大 */
}

/* 罰單圖片區域的樣式 */
img {
  border: 2px solid #ccc;
  border-radius: 10px;
}
</style>
