<template>
    <div class="flex-1 bg-gray-800 rounded-lg border border-gray-700 p-4 m-4">
      <h2 class="text-xl font-semibold text-white mb-4">{{ title }}</h2>
      <div v-if="images.length > 0" class="image-container rounded-lg border border-gray-600">
        <img
          :src="`data:image/jpeg;base64,${images[currentImageIndex]}`"
          :alt="'車牌照片 ' + (currentImageIndex + 1)"
          class="w-full h-full object-contain"
        />
      </div>
      <div v-else>
        <p class="text-white">無法載入圖片</p>
      </div>
      <div class="flex gap-2 justify-center mt-4">
        <!-- 切換圖片按鈕 -->
        <button
          @click="prevImage"
          class="p-2 rounded bg-gray-600 hover:bg-gray-700 text-white"
        >
          <i class="fas fa-chevron-left text-xl"></i>
        </button>
        <button
          @click="nextImage"
          class="p-2 rounded bg-gray-600 hover:bg-gray-700 text-white"
        >
          <i class="fas fa-chevron-right text-xl"></i>
        </button>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, computed, onMounted } from "vue";
  import { getUnrecognizedPlates } from "@/services/photoService";
  
  export default {
    props: {
      title: {
        type: String,
        default: "圖片檢視器",
      },
    },
    setup() {
      const images = ref([]);
      const currentImageIndex = ref(0);
  
      // 加載圖片
      const loadImages = async () => {
        try {
          const response = await getUnrecognizedPlates();
          images.value = response.data.map((entry) => entry[11]); // 第 11 個字段是圖片
        } catch (error) {
          console.error("無法加載圖片資料：", error);
        }
      };
  
      const currentImage = computed(() => images.value[currentImageIndex.value]);
  
      const nextImage = () => {
        currentImageIndex.value =
          (currentImageIndex.value + 1) % images.value.length;
      };
  
      const prevImage = () => {
        currentImageIndex.value =
          (currentImageIndex.value - 1 + images.value.length) %
          images.value.length;
      };
  
      onMounted(() => {
        loadImages();
      });
  
      return {
        images,
        currentImageIndex,
        currentImage,
        nextImage,
        prevImage,
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
  