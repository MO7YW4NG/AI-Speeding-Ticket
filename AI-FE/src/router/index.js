import { createRouter, createWebHashHistory } from "vue-router";
import ImageViewer from "../components/ImageViewer.vue";
import Form from "../components/Form.vue";
import ViolationForm from "../components/ViolationForm.vue";

const routes = [
  {
    path: "/",
    redirect: "/test1",
  },
  {
    path: "/test1",
    name: "RecognitionSystem",
    component: {
      template: `
        <div class="flex flex-1">
          <ImageViewer :zoomable="true" title="車牌檢視器" />
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
          <ImageViewer :zoomable="false" title="違規車輛檢視器" />
          <ViolationForm />
        </div>
      `,
      components: {
        ImageViewer,
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
