#include "ManagerBUS.h"
#include "FeedbackBUS.h"
#include <iostream>

// BUS processes WorkerDTO objects and displays their status
void ManagerBUS::checkWorkerStatus(const std::vector<WorkerDTO>& workersDTO) {
    for (const auto& w : workersDTO) {
        std::cout << "Worker Code: " << w.workerCode
                  << " | Area: " << w.workingArea
                  << " | Shift: " << w.shift
                  << " | Status: " << (w.available ? "Available" : "Unavailable") << "\n";
    }
}

// BUS retrieves FeedbackDTO from FeedbackBUS (which gets from DAL)
std::vector<FeedbackDTO> ManagerBUS::getUserFeedback() {
    // TODO: Call FeedbackBUS to get all feedback
    // return FeedbackBUS::getFeedbackByAccountId(managerId);
    return {};
}

// UI sends SettingDTO → BUS validates & updates → DAL persists → returns SettingDTO
std::optional<SettingDTO> ManagerBUS::updateSetting(const std::string& managerId,
                                                    const SettingDTO& settingDTO,
                                                    bool enableNotify,
                                                    bool enableEmail) {
    // Step 1: Create updated SettingDTO copy
    SettingDTO updatedSetting = settingDTO;
    updatedSetting.setNotification(enableNotify);
    updatedSetting.setEmail(enableEmail);
    
    // Step 2: Convert SettingDTO to BSON document
    // TODO: bsoncxx::document::value doc = convertSettingDTOToDocument(updatedSetting);
    
    // Step 3: Call DAL to upsert to DB
    // TODO: if (!SettingDAL::upsert(managerId, doc))
    //     return std::nullopt;
    
    // Step 4: Return updated SettingDTO back to UI
    return updatedSetting;
}
