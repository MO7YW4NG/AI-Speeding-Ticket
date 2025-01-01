export const submitTicket = async (payload) => {
    try {
      const response = await apiClient.post(`/new_ticket`, payload);
      return response.data;
    } catch (error) {
      console.error("Error submitting ticket:", error);
      throw error;
    }
  };
  