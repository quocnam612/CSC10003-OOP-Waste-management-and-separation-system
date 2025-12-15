#include "SettingsDAL.h"

vector<TrashTypeDTO> SettingsDAL::loadTrashTypes() { return {}; }
vector<RegionDTO> SettingsDAL::loadRegions() { return {}; }
NotificationConfigDTO SettingsDAL::loadNotificationConfig() { return {}; }
EmailConfigDTO SettingsDAL::loadEmailConfig() { return {}; }

void SettingsDAL::saveTrashTypes(const vector<TrashTypeDTO>& list) {}
void SettingsDAL::saveRegions(const vector<RegionDTO>& list) {}
void SettingsDAL::saveNotificationConfig(const NotificationConfigDTO& c) {}
void SettingsDAL::saveEmailConfig(const EmailConfigDTO& c) {}