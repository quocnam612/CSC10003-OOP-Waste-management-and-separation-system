#ifndef PROFILESERVICE_H
#define PROFILESERVICE_H

#include <string>
#include <optional>
#include "../dto/ProfileDTO.h"
#include "../dal/ProfileDAL.h"

class ProfileBUS {
public:
    // UI sends ProfileDTO & data → BUS validates & updates → DAL persists → returns ProfileDTO
    static std::optional<ProfileDTO> updateProfile(const std::string& accountId,
                                                    const ProfileDTO& profileDTO,
                                                    const std::string& name,
                                                    const std::string& phone,
                                                    const std::string& address);

    // BUS queries DAL → returns ProfileDTO to UI
    static std::optional<ProfileDTO> getProfile(const std::string& accountId);
    
    // UI sends old & new password → BUS validates → updates passwordHash → DAL persists
    static bool changePassword(const std::string& accountId,
                              const std::string& oldPwd,
                              const std::string& newPwd);
    
    // BUS validates ProfileDTO structure
    static bool validateProfileData(const ProfileDTO& profileDTO);
};

#endif