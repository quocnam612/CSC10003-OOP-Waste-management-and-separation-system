#include "ProfileService.h"
using std::vector;

bool ProfileService::changePassword(string userId, string oldPass, string newPass) {
    vector<UserDTO> users = userDAL.readUsers();
    bool correctOldPass = false;
    for (const auto& u : users) {
        if (u.getId() == userId && u.getPassword() == oldPass) {
            correctOldPass = true;
            break;
        }
    }
    if (!correctOldPass) return false;
    return profileDAL.updatePassword(userId, newPass);
}

bool ProfileService::updateProfile(string userId, string name, string phone, string loc) {
    ProfileDTO dto(name, phone, loc);
    return profileDAL.updateInfo(userId, dto);
}