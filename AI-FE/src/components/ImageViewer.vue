<template>
    <div class="flex-1 bg-gray-800 rounded-lg border border-gray-700 p-4 m-4">
      <h2 class="text-xl font-semibold text-white mb-4">{{ title }}</h2>
      <div v-if="filteredImages.length > 0" class="image-container rounded-lg border border-gray-600">
        <img
          :src="`data:image/jpeg;base64,${filteredImages[currentImageIndex]}`"
          :alt="'車牌照片' + (currentImageIndex + 1)"
          class="w-full h-full object-contain"
        />
      </div>
      <div v-else>
        <p class="text-white">無法載入圖片</p>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, onMounted, watch } from "vue";
  import { getAllIssuableViolations, getAllUnrecognizedViolations } from "@/services/violationService";
  
  export default {
    props: {
      title: {
        type: String,
        default: "圖片檢視器",
      },
      isViolationSystem: {
        type: Boolean, // 確定是違規開單系統還是人工辨識系統
        default: false,
      },
      currentImageIndex: {
        type: Number,
        required: true, // 從父組件接收圖片索引
      },
    },
    emits: ["updateImageIndex"], // 向父組件傳遞圖片索引更新
    setup(props, { emit }) {
      const plates = ref([]); // 所有的違規數據
      const filteredImages = ref([]); // 過濾後的圖片數據
  
      // 加載圖片數據
      const loadImages = async () => {
        try {
          let response;
          if (props.isViolationSystem) {
            // 違規開單系統
            response = await getAllIssuableViolations("EMP001", "192.168.0.1");
          } else {
            // 人工辨識系統
            response = await getAllUnrecognizedViolations("EMP001", "192.168.0.1");
          }
  
          if (response.data && response.data.length > 0) {
            plates.value = response.data;
            filteredImages.value = plates.value
              .map((entry) => entry[10] || "") // 假設第10欄是圖片Base64
              .filter((image) => image); // 過濾掉空圖片
            if (filteredImages.value.length > 0) {
              emit("updateImageIndex", 0); // 初始化為第一張
            }
          } else {
            console.warn("沒有獲取到圖片數據");
            filteredImages.value = [];
          }
        } catch (error) {
          console.error("無法加載圖片資料：", error);
          filteredImages.value = [];
        }
      };
  
      // 監控圖片索引的變化，確保不超出範圍
      watch(
        () => props.currentImageIndex,
        (newIndex) => {
          if (newIndex < 0 || newIndex >= filteredImages.value.length) {
            console.warn("圖片索引超出範圍");
          }
        }
      );
  
      onMounted(() => {
        loadImages();
      });
  
      return {
        filteredImages,
      };
    },
  };
  </script>
  
  <style>
  .image-container {
    position: relative;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 80vh;
  }
  
  .image-container img {
    max-width: 100%;
    max-height: 100%;
    transition: transform 0.3s ease;
  }
  </style>
  