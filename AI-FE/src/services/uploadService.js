export const uploadDriverData = async (payload, file) => {
    const formData = new FormData();
    formData.append("serialID", payload.serialID);
    formData.append("ip", payload.ip);
    formData.append("employerID", payload.employerID);
    formData.append("category", payload.category);
    formData.append("date", payload.date);
    formData.append("license_number", payload.license_number);
    formData.append("file", file);
  
    try {
      const response = await apiClient.post(`/upload`, formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });
      return response.data;
    } catch (error) {
      console.error("Error uploading driver data:", error);
      throw error;
    }
  };
  