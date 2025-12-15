#ifndef SETTINGSDAL_H
#define SETTINGSDAL_H

#include "../dto/settings/TrashTypeDTO.h"
#include "../dto/settings/RegionDTO.h"
#include "../dto/settings/NotificationConfigDTO.h"
#include "../dto/settings/EmailConfigDTO.h"
#include <vector>

class SettingsDAL {
public:
    vector<TrashTypeDTO> loadTrashTypes();
    vector<RegionDTO> loadRegions();
    NotificationConfigDTO loadNotificationConfig();
    EmailConfigDTO loadEmailConfig();

    void saveTrashTypes(const vector<TrashTypeDTO>& list);
    void saveRegions(const vector<RegionDTO>& list);
    void saveNotificationConfig(const NotificationConfigDTO& c);
    void saveEmailConfig(const EmailConfigDTO& c);
};

#endif