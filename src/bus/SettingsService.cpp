#include "SettingsService.h"

void SettingsService::saveTrashTypes(const vector<TrashTypeDTO>& list) { dal.saveTrashTypes(list); }
void SettingsService::saveRegions(const vector<RegionDTO>& list) { dal.saveRegions(list); }
void SettingsService::saveNotificationConfig(const NotificationConfigDTO& c) { dal.saveNotificationConfig(c); }
void SettingsService::saveEmailConfig(const EmailConfigDTO& c) { dal.saveEmailConfig(c); }