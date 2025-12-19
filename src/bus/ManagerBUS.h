#ifndef MANAGERBUS_H
#define MANAGERBUS_H

#include <vector>
#include <optional>
#include "../dto/WorkerDTO.h"
#include "../dto/FeedbackDTO.h"
#include "../dto/SettingDTO.h"
#include "../dal/SettingDAL.h"

class ManagerBUS {
public:
    // BUS processes vector of WorkerDTO and displays status
    static void checkWorkerStatus(const std::vector<WorkerDTO>& workersDTO);
    
    // BUS retrieves all FeedbackDTO from DAL
    static std::vector<FeedbackDTO> getUserFeedback();
    
    // UI sends SettingDTO → BUS validates & updates → DAL persists → returns SettingDTO
    static std::optional<SettingDTO> updateSetting(const std::string& managerId,
                                                    const SettingDTO& settingDTO,
                                                    bool enableNotify,
                                                    bool enableEmail);
};
#endif