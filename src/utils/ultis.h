#ifndef _ULTIS_H_
#define _ULTIS_H_
#include <ctime>
#include <string>
#include <vector>
#include "../dto/CityMap.h"
using std::string, std::vector, std::pair;

namespace utils {
    void convertToMatrix(const CityMap& map, vector<vector<double>>& matrix);
    void readMap(const string& filename, CityMap& map);
    void readRequiredNodes(const string& filename, vector<int>& nodes);
}

#endif // _ULTIS_H_