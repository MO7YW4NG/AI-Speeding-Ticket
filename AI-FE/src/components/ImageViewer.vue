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
       
      </div>
    </div>
  </template>
  
  <script>
import { ref, onMounted } from "vue";
import { getUnrecognizedPlates } from "@/services/photoService";
import eventBus from "@/components/eventBus";

export default {
  props: {
    title: {
      type: String,
      default: "圖片檢視器",
    },
  },
  setup() {
    // 保存圖片數據
    const images = ref([]);
    // 設置當前圖片索引，使用全局共享的 EventBus
    const currentImageIndex = eventBus.currentImageIndex;

    // 加載圖片數據
    const loadImages = async () => {
      try {
        const response = await getUnrecognizedPlates();
        if (response.data && response.data.length > 0) {
          // 解析並保存圖片的 base64 數據
          images.value = response.data.map((entry) => entry[10]); // 確認是圖片欄位的索引
        } else {
          console.warn("沒有獲取到圖片數據");
        }
      } catch (error) {
        console.error("無法加載圖片資料：", error);
      }
    };

    // 切換到下一張圖片
    const nextImage = () => {
      eventBus.nextImage(images.value.length);
    };

    // 切換到上一張圖片
    const prevImage = () => {
      eventBus.prevImage(images.value.length);
    };

    // 組件掛載後加載圖片數據
    onMounted(() => {
      loadImages();
    });

    return {
      images,
      currentImageIndex,
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
  