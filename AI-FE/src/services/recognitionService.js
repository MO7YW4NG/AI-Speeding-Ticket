import apiClient from "./api";

  export const getAllUnrecognizedViolations = (employeeId, processorIp) => {
    return apiClient.get(`/violation/get_all_unrecognized?employee_id=${employeeId}&processor_ip=${processorIp}`);
  };  

  export const updateStatus = (violationId, payload) => {
    // payload = { new_license_plate, employee_id, processor_ip, respond_code }
    return apiClient.post(`/violation/update_status/${violationId}`, payload);
  };