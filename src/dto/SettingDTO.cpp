#include "SettingDTO.h"

SettingDTO::SettingDTO()
    : enableNotification(true),
      enableEmail(true),
      systemName("Waste Management System"),
      maintenanceMessage("") {}

SettingDTO::SettingDTO(bool n,
                       bool e,
                       const string& s,
                       const string& m)
    : enableNotification(n),
      enableEmail(e),
      systemName(s),
      maintenanceMessage(m) {}

bool SettingDTO::isNotificationEnabled() const { return enableNotification; }
bool SettingDTO::isEmailEnabled() const { return enableEmail; }
const string& SettingDTO::getSystemName() const { return systemName; }
const string& SettingDTO::getMaintenanceMessage() const { return maintenanceMessage; }

void SettingDTO::setNotification(bool v) { enableNotification = v; }
void SettingDTO::setEmail(bool v) { enableEmail = v; }
void SettingDTO::setSystemName(const string& v) { systemName = v; }
void SettingDTO::setMaintenanceMessage(const string& v) { maintenanceMessage = v; }