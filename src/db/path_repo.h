#pragma once

#include <vector>

#include <bsoncxx/document/value.hpp>
#include <bsoncxx/document/view_or_value.hpp>

class PathRepository {
public:
    static bool insertPath(const bsoncxx::document::view_or_value& pathDoc);
    static std::vector<bsoncxx::document::value> findPathsByRegion(int region);
    static std::vector<bsoncxx::document::value> findPathsByRegionAndTeam(int region, int team);
};
