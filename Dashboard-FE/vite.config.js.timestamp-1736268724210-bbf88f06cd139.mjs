// vite.config.js
import { defineConfig } from "file:///opt/Dashboard-FE/node_modules/vite/dist/node/index.js";
import vue from "file:///opt/Dashboard-FE/node_modules/@vitejs/plugin-vue/dist/index.mjs";
import viteCompression from "file:///opt/Dashboard-FE/node_modules/vite-plugin-compression/dist/index.mjs";
var vite_config_default = defineConfig({
  plugins: [vue(), viteCompression()],
  build: {
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (id.includes("node_modules")) {
            return id.toString().split("node_modules/")[1].split("/")[0].toString();
          }
        }
      }
    },
    chunkSizeWarningLimit: 1600
  },
  base: "/",
  server: {
    host: "0.0.0.0",
    port: 80,
    proxy: {
      "/api/dev": {
        target: "http://dashboard-be:8080",
        changeOrigin: true,
        rewrite: (path) => path.replace("/dev", "/v1")
      },
      "/geo_server": {
        target: "https://geoserver.tuic.gov.taipei/geoserver/",
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/geo_server/, "")
      }
    },
    watch: {
      usePolling: true
    }
  }
});
export {
  vite_config_default as default
};
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsidml0ZS5jb25maWcuanMiXSwKICAic291cmNlc0NvbnRlbnQiOiBbImNvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9kaXJuYW1lID0gXCIvb3B0L0Rhc2hib2FyZC1GRVwiO2NvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9maWxlbmFtZSA9IFwiL29wdC9EYXNoYm9hcmQtRkUvdml0ZS5jb25maWcuanNcIjtjb25zdCBfX3ZpdGVfaW5qZWN0ZWRfb3JpZ2luYWxfaW1wb3J0X21ldGFfdXJsID0gXCJmaWxlOi8vL29wdC9EYXNoYm9hcmQtRkUvdml0ZS5jb25maWcuanNcIjtpbXBvcnQgeyBkZWZpbmVDb25maWcgfSBmcm9tIFwidml0ZVwiO1xyXG5pbXBvcnQgdnVlIGZyb20gXCJAdml0ZWpzL3BsdWdpbi12dWVcIjtcclxuaW1wb3J0IHZpdGVDb21wcmVzc2lvbiBmcm9tIFwidml0ZS1wbHVnaW4tY29tcHJlc3Npb25cIjtcclxuXHJcbi8vIGh0dHBzOi8vdml0ZWpzLmRldi9jb25maWcvXHJcbmV4cG9ydCBkZWZhdWx0IGRlZmluZUNvbmZpZyh7XHJcblx0cGx1Z2luczogW3Z1ZSgpLCB2aXRlQ29tcHJlc3Npb24oKV0sXHJcblx0YnVpbGQ6IHtcclxuXHRcdHJvbGx1cE9wdGlvbnM6IHtcclxuXHRcdFx0b3V0cHV0OiB7XHJcblx0XHRcdFx0bWFudWFsQ2h1bmtzKGlkKSB7XHJcblx0XHRcdFx0XHRpZiAoaWQuaW5jbHVkZXMoXCJub2RlX21vZHVsZXNcIikpIHtcclxuXHRcdFx0XHRcdFx0cmV0dXJuIGlkXHJcblx0XHRcdFx0XHRcdFx0LnRvU3RyaW5nKClcclxuXHRcdFx0XHRcdFx0XHQuc3BsaXQoXCJub2RlX21vZHVsZXMvXCIpWzFdXHJcblx0XHRcdFx0XHRcdFx0LnNwbGl0KFwiL1wiKVswXVxyXG5cdFx0XHRcdFx0XHRcdC50b1N0cmluZygpO1xyXG5cdFx0XHRcdFx0fVxyXG5cdFx0XHRcdH0sXHJcblx0XHRcdH0sXHJcblx0XHR9LFxyXG5cdFx0Y2h1bmtTaXplV2FybmluZ0xpbWl0OiAxNjAwLFxyXG5cdH0sXHJcblx0YmFzZTogXCIvXCIsXHJcblx0c2VydmVyOiB7XHJcblx0XHRob3N0OiBcIjAuMC4wLjBcIixcclxuXHRcdHBvcnQ6IDgwLFxyXG5cdFx0cHJveHk6IHtcclxuXHRcdFx0XCIvYXBpL2RldlwiOiB7XHJcblx0XHRcdFx0dGFyZ2V0OiBcImh0dHA6Ly9kYXNoYm9hcmQtYmU6ODA4MFwiLFxyXG5cdFx0XHRcdGNoYW5nZU9yaWdpbjogdHJ1ZSxcclxuXHRcdFx0XHRyZXdyaXRlOiAocGF0aCkgPT4gcGF0aC5yZXBsYWNlKFwiL2RldlwiLCBcIi92MVwiKSxcclxuXHRcdFx0fSxcclxuXHRcdFx0XCIvZ2VvX3NlcnZlclwiOiB7XHJcblx0XHRcdFx0dGFyZ2V0OiBcImh0dHBzOi8vZ2Vvc2VydmVyLnR1aWMuZ292LnRhaXBlaS9nZW9zZXJ2ZXIvXCIsXHJcblx0XHRcdFx0Y2hhbmdlT3JpZ2luOiB0cnVlLFxyXG5cdFx0XHRcdHJld3JpdGU6IChwYXRoKSA9PiBwYXRoLnJlcGxhY2UoL15cXC9nZW9fc2VydmVyLywgXCJcIiksXHJcblx0XHRcdH0sXHJcblx0XHR9LFxyXG5cdFx0d2F0Y2g6IHtcclxuXHRcdFx0dXNlUG9sbGluZzogdHJ1ZSxcclxuXHRcdH0sXHJcblx0fSxcclxufSk7XHJcbiJdLAogICJtYXBwaW5ncyI6ICI7QUFBcU8sU0FBUyxvQkFBb0I7QUFDbFEsT0FBTyxTQUFTO0FBQ2hCLE9BQU8scUJBQXFCO0FBRzVCLElBQU8sc0JBQVEsYUFBYTtBQUFBLEVBQzNCLFNBQVMsQ0FBQyxJQUFJLEdBQUcsZ0JBQWdCLENBQUM7QUFBQSxFQUNsQyxPQUFPO0FBQUEsSUFDTixlQUFlO0FBQUEsTUFDZCxRQUFRO0FBQUEsUUFDUCxhQUFhLElBQUk7QUFDaEIsY0FBSSxHQUFHLFNBQVMsY0FBYyxHQUFHO0FBQ2hDLG1CQUFPLEdBQ0wsU0FBUyxFQUNULE1BQU0sZUFBZSxFQUFFLENBQUMsRUFDeEIsTUFBTSxHQUFHLEVBQUUsQ0FBQyxFQUNaLFNBQVM7QUFBQSxVQUNaO0FBQUEsUUFDRDtBQUFBLE1BQ0Q7QUFBQSxJQUNEO0FBQUEsSUFDQSx1QkFBdUI7QUFBQSxFQUN4QjtBQUFBLEVBQ0EsTUFBTTtBQUFBLEVBQ04sUUFBUTtBQUFBLElBQ1AsTUFBTTtBQUFBLElBQ04sTUFBTTtBQUFBLElBQ04sT0FBTztBQUFBLE1BQ04sWUFBWTtBQUFBLFFBQ1gsUUFBUTtBQUFBLFFBQ1IsY0FBYztBQUFBLFFBQ2QsU0FBUyxDQUFDLFNBQVMsS0FBSyxRQUFRLFFBQVEsS0FBSztBQUFBLE1BQzlDO0FBQUEsTUFDQSxlQUFlO0FBQUEsUUFDZCxRQUFRO0FBQUEsUUFDUixjQUFjO0FBQUEsUUFDZCxTQUFTLENBQUMsU0FBUyxLQUFLLFFBQVEsaUJBQWlCLEVBQUU7QUFBQSxNQUNwRDtBQUFBLElBQ0Q7QUFBQSxJQUNBLE9BQU87QUFBQSxNQUNOLFlBQVk7QUFBQSxJQUNiO0FBQUEsRUFDRDtBQUNELENBQUM7IiwKICAibmFtZXMiOiBbXQp9Cg==
