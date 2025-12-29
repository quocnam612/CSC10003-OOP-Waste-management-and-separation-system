#pragma once

#include <vector>
#include <string>

struct RegionRecord {
    int id;
    std::string name;
    std::vector<std::string> districts;
};

class RegionRepository {
public:
    static std::vector<RegionRecord> getAllRegions();
};
