
#ifndef SETTINGDTO_H
#define SETTINGDTO_H

#include "../base.h"

class SettingDTO : public BaseDTO {
protected:
    string settingName; 
    bool isActive;

public:
    SettingDTO(string id, string name) 
        : BaseDTO(id), settingName(name), isActive(true) {}
    
    virtual ~SettingDTO() {}
    
    string getSettingName() const { return settingName; }
    bool getIsActive() const { return isActive; }
    void setIsActive(bool status) { isActive = status; }
};
#endif