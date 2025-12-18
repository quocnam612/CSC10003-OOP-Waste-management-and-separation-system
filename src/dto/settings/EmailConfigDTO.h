#include "SettingDTO.h"
class EmailConfigDTO : public SettingDTO {
private:
    string adminEmail;
public:
    EmailConfigDTO(string id, string email): SettingDTO(id, "Email Config"), adminEmail(email) {}
    string getAdminEmail() const { return adminEmail; }
};