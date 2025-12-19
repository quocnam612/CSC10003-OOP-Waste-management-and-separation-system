#ifndef SETTINGDAL_H
#define SETTINGDAL_H

#include <string>
#include <optional>
#include <bsoncxx/v_noabi/bsoncxx/document/value.hpp>

class SettingDAL {
public:
    static bool upsert(const std::string& managerId,
                       const bsoncxx::document::value& settingDoc);

    static std::optional<bsoncxx::document::value>
    getByManagerId(const std::string& managerId);
};
#endif // SETTINGDAL_H