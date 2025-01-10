import apiClient from "./api";


export const getVehicleDetails = (owner_name,owner_address ) => {
    return apiClient.get(`/violation/get?owner_name=${owner_name}&owner_address=${owner_address}`);
};

// 獲取所有需要人工辨識的違規數據 (status_code == 11 或 12)
export const getAllUnrecognizedViolations = (employeeId, processorIp) => {
    return apiClient.get(`/violation/get_all_unrecognized?employee_id=${employeeId}&processor_ip=${processorIp}`);
  };
  
  // 獲取所有可開單的違規數據 (status_code 不等於 11 和 12)
  export const getAllIssuableViolations = (employeeId, processorIp) => {
    return apiClient.get(`/violation/get_all_issuable?employee_id=${employeeId}&processor_ip=${processorIp}`);
  };

  export const issueNewViolation = (violationId,employeeId ,processorIp) => {
    return apiClient.post(`/violation/issue?employee_id=${employeeId}&processor_ip=${processorIp}&violation_id=${violationId}`);
  };