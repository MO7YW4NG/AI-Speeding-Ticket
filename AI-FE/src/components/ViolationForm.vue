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
            <input
              type="text"
              :value="formData.violationId"
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
  
          <!-- 選擇可以開單的資料 -->
          <div class="flex flex-col mt-4">
            <label class="text-md text-gray-400 mb-1">選擇可以開單的資料</label>
            <select
              v-model="selectedViolation"
              @change="populateForm"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100"
            >
              <option
                v-for="violation in issuableViolations"
                :key="violation.violation_id"
                :value="violation"
              >
                違規 ID: {{ violation.violation_id }} - 車牌號碼: {{ violation.license_plate }}
              </option>
            </select>
          </div>
  
          <!-- 圖片與按鈕的並排區域 -->
          <div class="flex mt-6 space-x-4 items-start">
            <!-- 左半邊圖片 -->
            <div class="w-1/2 flex justify-center items-center">
              <img
                src="/assets/Jufa_tongzhidan.jpg"
                alt="罰單圖片"
                class="w-auto max-h-[300px] rounded-md border border-gray-600"
              />
            </div>
  
            <!-- 右半邊按鈕 -->
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
              @click="showModal = false"
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
  import { reactive, ref, computed, onMounted } from "vue";
  import { getAllIssuableViolations, createNewTicket } from "@/services/violationService";
  import eventBus from "@/components/eventBus";
  
  export default {
    setup() {
      // 表單數據
      const formData = reactive({
        violationId: "",
        licensePlate: "",
        violationFact: "",
      });
  
      const currentTime = ref("");
      const showModal = ref(false);
      const issuableViolations = ref([]);
      const selectedViolation = ref(null);
      const currentImageIndex = eventBus.currentImageIndex; // 使用事件總線共享索引
  
      // 更新時間
      const updateTime = () => {
        const now = new Date();
        currentTime.value = now.toLocaleString();
      };
  
      // 獲取違規資料
      const fetchIssuableViolations = async () => {
        try {
          const response = await getAllIssuableViolations();
          issuableViolations.value = response.data;
          if (issuableViolations.value.length > 0) populateForm(0); // 初始化表單
        } catch (error) {
          console.error("獲取可開單資料失敗:", error);
        }
      };
  
      // 更新表單數據
      const populateForm = (index) => {
        const violation = issuableViolations.value[index];
        if (violation) {
          formData.violationId = violation.violation_id;
          formData.licensePlate = violation.license_plate;
          formData.violationFact = violation.violation_fact || "違規描述";
        }
      };
  
      // 切換到下一張圖片
      const nextImage = () => {
        eventBus.nextImage(issuableViolations.value.length);
        populateForm(currentImageIndex.value);
      };
  
      // 切換到上一張圖片
      const prevImage = () => {
        eventBus.prevImage(issuableViolations.value.length);
        populateForm(currentImageIndex.value);
      };
  
      // 提交罰單
      const submitTicket = async () => {
        try {
          if (!formData.violationId || !formData.licensePlate || !formData.violationFact) {
            alert("請完整填寫表單！");
            return;
          }
          const payload = {
            violation_id: formData.violationId,
            license_plate: formData.licensePlate,
            violation_fact: formData.violationFact,
          };
          await createNewTicket(payload);
          alert("罰單提交成功！");
          fetchIssuableViolations();
          resetForm();
        } catch (error) {
          console.error("提交罰單失敗:", error);
          alert("提交罰單失敗，請稍後再試！");
        }
      };
  
      // 重置表單
      const resetForm = () => {
        formData.violationId = "";
        formData.licensePlate = "";
        formData.violationFact = "";
        selectedViolation.value = null;
      };
  
      // 預覽罰單
      const previewTicket = () => {
        showModal.value = true;
      };
  
      // 初始化
      onMounted(() => {
        updateTime();
        setInterval(updateTime, 1000);
        fetchIssuableViolations();
      });
  
      return {
        formData,
        currentTime,
        showModal,
        issuableViolations,
        selectedViolation,
        resetForm,
        submitTicket,
        populateForm,
        previewTicket,
        nextImage,
        prevImage,
        currentImageIndex,
      };
    },
  };
  </script>
  