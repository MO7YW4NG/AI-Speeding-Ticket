import { ref } from "vue";

const eventBus = {
  currentImageIndex: ref(0), // 全局共享的圖片索引
  nextImage(imagesLength) {
    if (imagesLength > 0) {
      this.currentImageIndex.value =
        (this.currentImageIndex.value + 1) % imagesLength;
    }
  },
  prevImage(imagesLength) {
    if (imagesLength > 0) {
      this.currentImageIndex.value =
        (this.currentImageIndex.value - 1 + imagesLength) % imagesLength;
    }
  },
};

export default eventBus;
