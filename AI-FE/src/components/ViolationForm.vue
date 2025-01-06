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
        </div>
  
        <div class="mt-6 flex">
          <!-- 左半邊資料選擇 -->
          <div class="flex-1 flex flex-col space-y-4">
            <h3 class="text-md text-gray-100 font-semibold">選擇可以開單的資料</h3>
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
  
          <!-- 右半邊按鈕 -->
          <div class="flex-1 flex flex-col justify-center space-y-4 pl-4">
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
  import { reactive, ref, onMounted } from "vue";
  import { getAllIssuableViolations, createNewTicket } from "@/services/violationService";
  
  export default {
    setup() {
      // 表單數據
      const formData = reactive({
        violationId: "", // 選中的違規 ID
        licensePlate: "", // 車牌號碼
        violationFact: "", // 違規事實
      });
  
      const currentTime = ref(""); // 系統當前時間
      const showModal = ref(false); // 是否顯示預覽彈窗
      const issuableViolations = ref([]); // 所有可開單資料
      const selectedViolation = ref(null); // 當前選中的違規數據
      const currentViolationIndex = ref(0); // 當前違規資料的索引
  
      // 更新當前時間
      const updateTime = () => {
        const now = new Date();
        currentTime.value = now.toLocaleString();
      };
  
      // 獲取所有可以開單的違規資料
      const fetchIssuableViolations = async () => {
        try {
          const response = await getAllIssuableViolations();
          issuableViolations.value = response.data; // 將數據存入響應式變量
          updateViolationForm(0); // 初始化表單為第一筆數據
        } catch (error) {
          console.error("獲取可開單資料失敗:", error);
        }
      };
  
      // 更新表單數據
      const updateViolationForm = (index) => {
        const violation = issuableViolations.value[index];
        if (violation) {
          formData.violationId = violation.violation_id;
          formData.licensePlate = violation.license_plate;
          formData.violationFact = violation.violation_fact || "違規描述";
        }
      };
  
      // 切換到下一個違規資料
      const nextViolation = () => {
        currentViolationIndex.value =
          (currentViolationIndex.value + 1) % issuableViolations.value.length;
        updateViolationForm(currentViolationIndex.value);
      };
  
      // 切換到上一個違規資料
      const prevViolation = () => {
        currentViolationIndex.value =
          (currentViolationIndex.value - 1 + issuableViolations.value.length) %
          issuableViolations.value.length;
        updateViolationForm(currentViolationIndex.value);
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
          fetchIssuableViolations(); // 重新獲取可以開單的資料
          resetForm(); // 重置表單
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
        showModal.value = true; // 顯示預覽彈窗
      };
  
      // 初始化
      onMounted(() => {
        updateTime(); // 更新當前時間
        setInterval(updateTime, 1000); // 每秒更新時間
        fetchIssuableViolations(); // 獲取可以開單的資料
      });
  
      return {
        formData,
        currentTime,
        showModal,
        issuableViolations,
        selectedViolation,
        resetForm,
        submitTicket,
        populateForm: updateViolationForm,
        nextViolation,
        prevViolation,
        previewTicket,
      };
    },
  };
  </script>
  