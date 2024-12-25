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
          <div class="flex flex-col">
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
            <div>
              <select
                v-model="formData.eventType"
                class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
                @change="handleEventTypeChange"
              >
                <option value="違規停車">違規停車</option>
                <option value="超速">超速</option>
                <option value="闖紅燈">闖紅燈</option>
                <option value="其他">其他</option>
              </select>
              <div v-if="formData.eventType === '其他'" class="mt-2">
                <input
                  type="text"
                  v-model="formData.otherEventType"
                  placeholder="請輸入其他事件類型"
                  class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
                />
              </div>
            </div>
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
          <!-- 左邊回報區域 -->
          <div class="flex-1 bg-gray-800 rounded-lg p-4 border border-gray-700">
            <h3 class="text-md text-gray-100 font-semibold mb-2">回報原因</h3>
            <div>
              <select
                v-model="formData.reportReason"
                class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md mb-2"
                @change="handleReportReasonChange"
              >
              <option value="無">無</option>
                <option value="圖片模糊">圖片模糊</option>
                <option value="車牌遮擋">車牌遮擋</option>
                <option value="其他">其他</option>
              </select>
              <div v-if="formData.reportReason === '其他'" class="mt-2">
                <input
                  type="text"
                  v-model="formData.otherReportReason"
                  placeholder="請輸入其他回報原因"
                  class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-gray-100 text-md"
                />
              </div>
            </div>
            <button @click="submitReport" class="w-full px-3 py-2 mt-4 rounded bg-red-600 hover:bg-red-700 text-white">
              確認回報
            </button>
          </div>
  
        <!-- 右邊提交區域 -->
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
  import { reactive, ref, onMounted } from 'vue';
  
  export default {
    setup() {
      const formData = reactive({
        aiErrorReason: '無法辨識車牌', // 預設固定錯誤原因
        licensePlate: '',
        eventType: '',
        otherEventType: '', // 用於「其他」事件類型輸入
        serialNumber: '12345678', // 示例舉發ID
        ip: '192.168.0.1', // 示例IP
        employeeId: 'EMP001', // 示例員工ID
        reportReason: '',
        otherReportReason: '', // 用於「其他」回報原因輸入
      });
  
      const currentTime = ref('');
  
      // 更新系統時間
      const updateTime = () => {
        const now = new Date();
        currentTime.value = now.toLocaleString();
      };
  
      onMounted(() => {
        updateTime();
        setInterval(updateTime, 1000); // 每秒更新一次時間
      });
  
      const resetForm = () => {
        formData.licensePlate = '';
        formData.eventType = '';
        formData.otherEventType = '';
      };
  
      const handleEventTypeChange = () => {
        if (formData.eventType !== '其他') {
          formData.otherEventType = ''; // 清空「其他」事件類型輸入
        }
      };
  
      const handleReportReasonChange = () => {
        if (formData.reportReason !== '其他') {
          formData.otherReportReason = ''; // 清空「其他」回報原因輸入
        }
      };
  
      const submitForm = () => {
        console.log('提交表單數據:', { ...formData, currentTime: currentTime.value });
      };
  
      const submitReport = () => {
        console.log('回報原因:', formData.reportReason, '其他原因:', formData.otherReportReason);
      };
  
      return {
        formData,
        currentTime,
        resetForm,
        handleEventTypeChange,
        handleReportReasonChange,
        submitForm,
        submitReport,
      };
    },
  };
  </script>
  
  <style>
  /**** 表單相關樣式 ****/
  </style>
  