import { ref } from "vue";

const eventBus = {
  imageIndices: {}, // 儲存每個圖片集的索引

  getIndex(key) {
    if (!this.imageIndices[key]) {
      this.imageIndices[key] = ref(0); // 初始化索引
    }
    return this.imageIndices[key];
  },

  nextImage(key, imagesLength) {
    if (imagesLength > 0) {
      const index = this.getIndex(key);
      index.value = (index.value + 1) % imagesLength;
    }
  },

  prevImage(key, imagesLength) {
    if (imagesLength > 0) {
      const index = this.getIndex(key);
      index.value = (index.value - 1 + imagesLength) % imagesLength;
    }
  },
};

export default eventBus;
