<template>
    <div class="flex-1 bg-gray-800 rounded-lg border border-gray-700 p-4 m-4">
      <h2 class="text-xl text-gray-100 font-semibold mb-4">違規開單系統</h2>
  
      <div class="p-4">
        <div class="flex flex-col space-y-4">
          <!-- 時間 -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">時間</label>
            <input
              type="text"
              :value="currentTime"
              readonly
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 舉發 ID -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">舉發 ID</label>
            <!-- 綁定 formData.serialNumber -->
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
              placeholder="請輸入車牌號碼"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            />
          </div>
  
          <!-- 違規事實 -->
          <div class="flex flex-col">
            <label class="text-md text-gray-400 mb-1">違規事實</label>
            <textarea
              v-model="formData.violationFact"
              rows="2"
              placeholder="請輸入違規事實"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
            ></textarea>
          </div>
  
          <!-- 下拉式選單: 選擇可以開單的資料 -->
          <div class="flex flex-col mt-4">
            <label class="text-md text-gray-400 mb-1">選擇可以開單的資料</label>
            <select
              v-model="selectedViolation"
              @change="populateForm"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100"
            >
              <!-- issuableViolations為後端返回的可開單違規資料陣列 -->
              <option
                v-for="(violation, idx) in issuableViolations"
                :key="idx"
                :value="violation"
              >
                <!-- 這裡假設 violation[0] 是ID, violation[6]是車牌 -->
                違規 ID: {{ violation[0] }} - 車牌號碼: {{ violation[6] }}
              </option>
            </select>
          </div>
  
          <!-- 圖片與按鈕並排區域 -->
          <div class="flex mt-6 space-x-4 items-start">
            <!-- 左側圖片 -->
            <div class="w-1/2 flex justify-center items-center">
              <img
                src="/assets/Jufa_tongzhidan.jpg"
                alt="罰單圖片"
                class="w-auto max-h-[300px] rounded-md border border-gray-600"
              />
            </div>
  
            <!-- 右側按鈕 -->
            <div class="w-1/2 flex flex-col justify-center space-y-4">
              <button
                @click="previewTicket"
                class="w-full px-3 py-2 bg-yellow-600 hover:bg-yellow-700 text-white rounded-lg"
              >
                預覽罰單
              </button>
              <button
                @click="resetForm"
                class="w-full px-3 py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-lg"
              >
                重置
              </button>
              <button
                @click="submitTicket"
                class="w-full px-3 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg"
              >
                提交罰單
              </button>
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
  
        <!-- 預覽罰單的彈窗 -->
        <div
          v-if="showModal"
          class="fixed inset-0 bg-black bg-opacity-75 flex justify-center items-center"
        >
          <div class="relative bg-gray-800 p-4 rounded-lg">
            <button
              @click="closePreview"
              class="absolute top-2 right-2 px-2 py-1 bg-red-600 hover:bg-red-700 text-white rounded"
            >
              關閉
            </button>
            <img
              src="/assets/Jufa_tongzhidan.jpg"
              alt="罰單預覽"
              class="max-w-full max-h-[80vh] rounded-md"
            />
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
import { reactive, ref, onMounted } from "vue";
import { getUnrecognizedPlates, createNewTicket } from "@/services/violationService";
import eventBus from "@/components/eventBus";

export default {
  setup() {
    // 表單資料
    const formData = reactive({
      serialNumber: "",   // 舉發ID
      licensePlate: "",   // 車牌號碼
      violationFact: "",  // 違規事實
    });

    // 其他狀態
    const currentTime = ref("");
    const showModal = ref(false);  // 控制「預覽罰單」彈窗
    const issuableViolations = ref([]); // 後端回傳的可開單資料
    const selectedViolation = ref(null); // 下拉選單中選中的那筆違規資料

    // 圖片相關
    const images = ref([]);
    const currentImageIndex = eventBus.currentImageIndex;

    // 每秒更新時間
    const updateTime = () => {
      currentTime.value = new Date().toLocaleString();
    };

    // 載入可開單資料 (這裡示範用 getUnrecognizedPlates, 可改成 getIssuableViolations)
    const fetchUnrecognizedPlates = async () => {
      try {
        const response = await getUnrecognizedPlates();
        // 後端回傳陣列，假設每筆形如 [violation_id, ..., license_plate, ..., image, status_code]
        issuableViolations.value = response.data;
        console.log("可開單資料：", issuableViolations.value);

        // 取出圖片
        images.value = issuableViolations.value.map((plate) => plate.image);

        // 如有資料就預設選擇第一筆
        if (issuableViolations.value.length > 0) {
          // 預設下拉式選單選擇第一筆
          selectedViolation.value = issuableViolations.value[0];
          populateForm();
        } else {
          resetForm();
        }
      } catch (error) {
        console.error("獲取可開單資料失敗:", error);
      }
    };

    // 下拉選單改變，填入表單
    const populateForm = () => {
      if (!selectedViolation.value) {
        resetForm();
        return;
      }
      const plate = selectedViolation.value;

      // 假設 plate[0] = violation_id, plate[6] = license_plate, plate[11] = status_code
      formData.serialNumber = plate[0] || "";
      formData.licensePlate = plate[6] || "";
      formData.violationFact = "預設違規事實";

      // 若需要根據 plate[11] (status_code) 決定 AI 錯誤原因等，可以在這裡處理
    };

    // 重置表單
    const resetForm = () => {
      formData.serialNumber = "";
      formData.licensePlate = "";
      formData.violationFact = "";
      selectedViolation.value = null;
    };

    // 預覽罰單 (打開彈窗)
    const previewTicket = () => {
      showModal.value = true;
    };

    // 關閉預覽罰單
    const closePreview = () => {
      showModal.value = false;
    };

    // 提交罰單
    const submitTicket = async () => {
      try {
        if (!formData.serialNumber || !formData.licensePlate || !formData.violationFact) {
          alert("請完整填寫表單！");
          return;
        }
        const payload = {
          violation_id: formData.serialNumber,
          license_plate: formData.licensePlate,
          violation_fact: formData.violationFact,
        };

        await createNewTicket(payload);
        alert("罰單提交成功！");
        // 重新載入資料 (若需要)
        fetchUnrecognizedPlates();
        resetForm();
      } catch (error) {
        console.error("提交罰單失敗:", error);
        alert("提交罰單失敗，請稍後再試！");
      }
    };

    // 切換圖片 (上一張/下一張)
    const nextImage = () => {
      eventBus.nextImage(images.value.length);
      // 如果想隨圖片切換更新表單，也可在這裡呼叫 updateFormData(index) (需定義)
    };

    const prevImage = () => {
      eventBus.prevImage(images.value.length);
      // 同上
    };

    // 組件掛載時
    onMounted(() => {
      updateTime();
      setInterval(updateTime, 1000);
      fetchUnrecognizedPlates();
    });

    return {
      // 資料
      formData,
      currentTime,
      showModal,
      issuableViolations,
      selectedViolation,
      images,
      currentImageIndex,

      // 方法
      resetForm,
      submitTicket,
      populateForm,
      previewTicket,
      closePreview,
      nextImage,
      prevImage,
    };
  },
};
</script>
