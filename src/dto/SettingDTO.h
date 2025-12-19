#ifndef SETTINGDTO_H
#define SETTINGDTO_H
#include <string>
using std::string;
class SettingDTO {
private:
    bool enableNotification;
    bool enableEmail;
    string systemName;
    string maintenanceMessage;

public:
    SettingDTO();
    SettingDTO(bool enableNotification,
               bool enableEmail,
               const string& systemName,
               const string& maintenanceMessage);

    bool isNotificationEnabled() const;
    bool isEmailEnabled() const;
    const string& getSystemName() const;
    const string& getMaintenanceMessage() const;

    void setNotification(bool value);
    void setEmail(bool value);
    void setSystemName(const string& value);
    void setMaintenanceMessage(const string& value);
};
#endif