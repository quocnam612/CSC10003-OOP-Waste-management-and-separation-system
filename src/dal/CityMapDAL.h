#ifndef CITYMAPDAL_H
#define CITYMAPDAL_H

#include <string>
#include <vector>
#include <optional>
#include <bsoncxx/v_noabi/bsoncxx/document/value.hpp>

class CityMapDAL {
public:
    static bool insert(const bsoncxx::document::value& doc);

    static std::optional<bsoncxx::document::value>
    getByCityName(const std::string& cityName);

    static std::vector<bsoncxx::document::value> getAll();

    static bool update(const std::string& cityName,
                       const bsoncxx::document::value& doc);
};
#endif // CITYMAPDAL_H