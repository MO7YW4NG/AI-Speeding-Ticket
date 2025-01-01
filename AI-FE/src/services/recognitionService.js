import apiClient from "./api";


export const createRecognitionForm = (formData) =>
  apiClient.post("/recognition/forms", {
    licensePlate: formData.licensePlate,
    eventType: formData.eventType,
  });
