#ifndef SETTINGSSERVICE_H
#define SETTINGSSERVICE_H

#include "../dal/SettingsDAL.h"
#include <vector>

class SettingsService {
private:
    SettingsDAL dal;

public:
    auto loadTrashTypes() { return dal.loadTrashTypes(); }
    auto loadRegions() { return dal.loadRegions(); }
    auto loadNotificationConfig() { return dal.loadNotificationConfig(); }
    auto loadEmailConfig() { return dal.loadEmailConfig(); }

    void saveTrashTypes(const vector<TrashTypeDTO>& list);
    void saveRegions(const vector<RegionDTO>& list);
    void saveNotificationConfig(const NotificationConfigDTO& c);
    void saveEmailConfig(const EmailConfigDTO& c);
};

#endif