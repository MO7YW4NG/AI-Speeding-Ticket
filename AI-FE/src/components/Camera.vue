<template>
    <div class="camera-container">
      <!-- 全螢幕閃光效果 -->
      <div v-if="showFlash" class="full-screen-flash"></div>
  
      <!-- 隨機分布的照片 -->
      <div
        v-for="(photo, index) in randomPhotos"
        :key="index"
        class="photo-frame"
        :style="photo.style"
      >
        <img :src="photo.src" alt="隨機照片" />
      </div>
  
      <!-- 相機本體 -->
      <div class="camera">
        <!-- 鏡頭區域 -->
        <div class="lens">
          <div class="inner-lens"></div>
          <div class="glare"></div>
        </div>
  
        <!-- 快門按鈕 -->
        <button class="shutter" @click="triggerFlash">快門</button>
      </div>
  
      <!-- 啟動文字 -->
      <div v-if="showLoadingText" class="loading-text">系統啟動中...</div>
    </div>
  </template>
  
  <script>
  import axios from "axios";

  export default {
    data() {
      return {
        showFlash: false,
        showLoadingText: false,
        randomPhotos: [], // 隨機照片的資料
        formData: {
          filePath: "path/to/your/file.jpg" // 替換為實際的文件路徑
        }
      };
    },
    methods: {
      triggerFlash() {
        this.showFlash = true;
        this.showLoadingText = true;
  
        setTimeout(() => {
          const payload = {
            file_path: this.formData.filePath
          };
  
          axios.post('http://localhost:8000/process-violations', payload)
            .then(response => {
              console.log("API 回應：", response.data);
            })
            .catch(error => {
              console.error("啟動程式失敗：", error.response?.data || error.message);
              alert("系統啟動失敗，請稍後再試！");
              this.showLoadingText = false; // 隱藏啟動文字
            });
  
          // 模擬完成程序後跳轉
          setTimeout(() => {
            this.$router.push("/main"); // 替換為主要程式的路由
          }, 2000);
        }, 300); // 閃光動畫持續時間
      },
      generateRandomPhotos() {
        const photoCount = 12; // 隨機顯示的照片數量
        const photos = [
          "assets/test_images/000016_jpg.rf.c97809771715a84d0fcd5aba5148d0b8-k0qEaUg1.jpg",
          "assets/test_images/000023_jpg.rf.9ac21e72685c1ef723fd1592ea93e092-CVL71TE6.jpg",
          "assets/test_images/000025_jpg.rf.a6a3b711df4aec55e02bfc148bebd6b1-CKTZC0qc.jpg",
          "assets/test_images/000038_jpg.rf.1d147803db100ff365130d91872d6146-C_O9vEO5.jpg",
          "assets/test_images/000144_jpg.rf.290fc172f56bbc03ca322b3bab72f0da-DEtA4IUo.jpg",
          "assets/test_images/000081_jpg.rf.38f66ed412a230a37f041b83ea00aa66-CzpX_AnF.jpg",
          "assets/test_images/000103_jpg.rf.4d1bee8f94b7fa36056ff89b67b3be4a-CxMuJLUw.jpg",
          "assets/test_images/000189_jpg.rf.f104464b9db9f64b184d0a0e7dbb09ec-DzUtegWR.jpg",
        ];
  
        this.randomPhotos = Array.from({ length: photoCount }).map(() => {
          const randomX = Math.random() * 80 ; // 隨機 X 位置（10% - 90%）
          const randomY = Math.random() * 80 ; // 隨機 Y 位置（10% - 90%）
          const randomRotation = (Math.random() - 0.5) * 30; // 隨機旋轉（-15° ~ 15°）
  
          return {
            src: photos[Math.floor(Math.random() * photos.length)],
            style: {
              top: `${randomY}%`,
              left: `${randomX}%`,
              transform: `rotate(${randomRotation}deg)`,
            },
          };
        });
      },
    },
    mounted() {
      this.generateRandomPhotos(); // 初始化隨機照片
    },
  };
  </script>
  
  <style scoped>
  /* 整體容器 */
  .camera-container {
    width: 100vw;
    height: 100vh;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    background: linear-gradient(135deg, #1e1e1e, #3c3c3c);
    overflow: hidden;
    position: relative;
  }
  
  /* 全螢幕閃光效果 */
  .full-screen-flash {
    position: absolute;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: white;
    opacity: 0.8;
    z-index: 10;
    animation: flash 0.3s ease-in-out;
  }
  
  @keyframes flash {
    0% {
      opacity: 0;
    }
    50% {
      opacity: 0.8;
    }
    100% {
      opacity: 0;
    }
  }
  
  /* 隨機照片樣式 */
  .photo-frame {
    position: absolute;
    width: 400px;
    height: 400px;
    overflow: hidden;
    border: 5px solid #fff;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
    border-radius: 10px;
    transition: all 0.3s ease;
  }
  
  .photo-frame img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
  
  /* 相機本體 */
  .camera {
    width: 450px;
    height: 350px;
    background: linear-gradient(145deg, #333, #222);
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 20px;
    overflow: hidden;
    z-index: 10;
  }
  
  /* 鏡頭外框 */
  .lens {
    width: 150px;
    height: 150px;
    background: radial-gradient(circle, #000, #444);
    border: 10px solid #00aaff;
    border-radius: 50%;
    position: relative;
    box-shadow: 0 0 30px #00aaff, inset 0 0 20px rgba(0, 0, 0, 0.5);
  }
  
  /* 鏡頭內部 */
  .inner-lens {
    width: 90px;
    height: 90px;
    background: radial-gradient(circle, #444, #000);
    border-radius: 50%;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    box-shadow: inset 0 0 15px rgba(0, 0, 0, 0.7);
  }
  
  /* 鏡頭光澤 */
  .glare {
    width: 30px;
    height: 30px;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0));
    border-radius: 50%;
    position: absolute;
    top: 20%;
    left: 20%;
    transform: translate(-50%, -50%);
  }
  
  /* 快門按鈕 */
  .shutter {
    width: 120px;
    height: 50px;
    background: linear-gradient(145deg, #444, #666);
    border: 3px solid #333;
    border-radius: 25px;
    margin-top: 30px;
    text-align: center;
    font-size: 1rem;
    color: #fff;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
    cursor: pointer;
    transition: all 0.2s ease;
  }
  
  .shutter:hover {
    transform: scale(1.05);
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.6);
  }
  
  .shutter:active {
    transform: scale(0.95);
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.7);
  }
  
  /* 啟動文字 */
.loading-text {
  margin-top: 20px;
  font-size: 1.5rem;
  font-weight: bold;
  color: black;
  text-align: center;
  background: white;
  padding: 10px 20px;
  border-radius: 10px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
  border: 2px solid black;
  z-index: 1;
}
  
  @keyframes blink {
    0%,
    100% {
      opacity: 1;
    }
    50% {
      opacity: 0.5;
    }
  }
  </style>