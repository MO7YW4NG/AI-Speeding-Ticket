<template>
    <div class="flex flex-1">
      <ImageViewer :zoomable="true" title="車牌檢視器" />
      <Form />
    </div>
  </template>
  
  <script>
  import ImageViewer from "../components/ImageViewer.vue";
  import Form from "../components/Form.vue";
  
  export default {
    components: {
      ImageViewer,
      Form,
    },
  };
  </script>
  