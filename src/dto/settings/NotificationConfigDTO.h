#ifndef NOTIFICATIONCONFIGDTO_H
#define NOTIFICATIONCONFIGDTO_H

#include <string>
using namespace std;

struct NotificationConfigDTO {
    bool enableNotifications;
    string method;        
};

#endif