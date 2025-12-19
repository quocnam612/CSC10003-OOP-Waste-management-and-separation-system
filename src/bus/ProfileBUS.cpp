#include "ProfileBUS.h"
#include "Utils.h"

// UI sends ProfileDTO & fields → BUS validates & updates → DAL persists → returns ProfileDTO
std::optional<ProfileDTO> ProfileBUS::updateProfile(const std::string& accountId,
                                                    const ProfileDTO& profileDTO,
                                                    const std::string& name,
                                                    const std::string& phone,
                                                    const std::string& address) {
    // Step 1: Validate ProfileDTO and input data
    if (!validateProfileData(profileDTO))
        return std::nullopt;
    
    // Step 2: Create updated ProfileDTO copy
    ProfileDTO updatedProfile = profileDTO;
    updatedProfile.setFullName(name);
    updatedProfile.setPhone(phone);
    updatedProfile.setAddress(address);
    
    // Step 3: Convert ProfileDTO to BSON document
    // TODO: bsoncxx::document::value doc = convertProfileDTOToDocument(updatedProfile);
    
    // Step 4: Call DAL to upsert to DB
    // TODO: if (!ProfileDAL::upsert(accountId, doc))
    //     return std::nullopt;
    
    // Step 5: Return updated ProfileDTO back to UI
    return updatedProfile;
}

// BUS queries DAL and returns ProfileDTO to UI
std::optional<ProfileDTO> ProfileBUS::getProfile(const std::string& accountId) {
    // Step 1: Call DAL to fetch BSON document from DB
    // TODO: auto result = ProfileDAL::getByAccountId(accountId);
    
    // Step 2: Convert BSON document to ProfileDTO
    // TODO: if (result) {
    //         return convertDocumentToProfileDTO(*result);
    //     }
    
    return std::nullopt;
}

// UI sends accountId & passwords → BUS validates & updates → DAL persists
bool ProfileBUS::changePassword(const std::string& accountId,
                               const std::string& oldPwd,
                               const std::string& newPwd) {
    // Step 1: Get current profile from DAL
    // TODO: auto profile = getProfile(accountId);
    //     if (!profile) return false;
    
    // Step 2: Verify old password matches stored hash
    // TODO: if (Utils::hashPassword(oldPwd) != profile->passwordHash)
    //     return false;
    
    // Step 3: Hash new password
    // TODO: std::string newHash = Utils::hashPassword(newPwd);
    
    // Step 4: Call DAL to update password in DB
    // TODO: return ProfileDAL::updatePassword(accountId, newHash);
    
    return false;
}

// BUS validates ProfileDTO structure
bool ProfileBUS::validateProfileData(const ProfileDTO& profileDTO) {
    // Validate fullName is not empty
    // Validate phone format is valid (using Utils::isValidPhone)
    // Validate address is not empty
    return true;
}