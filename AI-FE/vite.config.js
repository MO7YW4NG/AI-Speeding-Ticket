// vite.config.js
import { fileURLToPath, URL } from "node:url";
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import vueDevTools from "vite-plugin-vue-devtools";
import viteCompression from "vite-plugin-compression";
// https://vite.dev/config/
export default defineConfig({
  plugins: [vue(), vueDevTools(), viteCompression()],
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
      vue: "vue/dist/vue.esm-bundler.js",
    },
  },
  server: {
    host: "0.0.0.0",
    // port: 81,
    // proxy: {
    //     "/api/dev": {
    //         target: "http://dashboard-be:8080",
    //         changeOrigin: true,
    //         rewrite: (path) => path.replace("/dev", "/v1"),
    //     },
    //     "/geo_server": {
    //         target: "https://geoserver.tuic.gov.taipei/geoserver/",
    //         changeOrigin: true,
    //         rewrite: (path) => path.replace(/^\/geo_server/, ""),
    //     },
    // },
    watch: {
      usePolling: true,
    },
  },
});
