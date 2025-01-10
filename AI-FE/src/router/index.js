import { createRouter, createWebHashHistory } from "vue-router";
import Form from "../components/Form.vue";
import ViolationForm from "../components/ViolationForm.vue";
import Final from "@/components/Final.vue";

// 定義路由
const routes = [
  {
    path: "/test1",
    name: "RecognitionSystem",
    component: Form, // 如果 `/test1` 是用來展示表單
  },
  {
    path: "/test2",
    name: "ViolationTicketSystem",
    component: ViolationForm, // `/test2` 使用 ViolationForm 作為主要頁面
  },
  {
    path: "/test3",
    name: "Final",
    component: Final, // `/test2` 使用 ViolationForm 作為主要頁面
  },
];

// 創建路由實例
const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;
