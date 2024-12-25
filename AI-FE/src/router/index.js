import { createRouter, createWebHashHistory } from "vue-router";
import ImageViewer from "../components/ImageViewer.vue";
import Form from "../components/Form.vue";
import ViolationImageViewer from "../components/ViolationImageViewer.vue";
import ViolationForm from "../components/ViolationForm.vue";

const routes = [
  {
    path: "/test1",
    name: "RecognitionSystem",
    component: {
      template: `
        <div class="flex flex-1">
          <ImageViewer />
          <Form />
        </div>
      `,
      components: {
        ImageViewer,
        Form,
      },
    },
  },
  {
    path: "/test2",
    name: "ViolationTicketSystem",
    component: {
      template: `
        <div class="flex flex-1">
          <ViolationImageViewer />
          <ViolationForm />
        </div>
      `,
      components: {
        ViolationImageViewer,
        ViolationForm,
      },
    },
  },
];

const router = createRouter({
  history: createWebHashHistory(import.meta.env.BASE_URL),
  routes,
});

export default router;
