#ifndef _CREATEROUTE_H_
#define _CREATEROUTE_H_

#include "../utils/ultis.h"
#include "../utils/graphUtils.h"
#include "../dto/CityMap.h"
#include "../bus/RoutePlanner.h"
#include <vector>
using std::vector;
using namespace graphUtils;

class CreateRoute : public RoutePlanner {
public:
    CreateRoute(const CityMap& map, const vector<int>& requiredCleanNodes);     
    pair<double, vector<int>> generateOptimalRoute();

};

#endif // _CREATEROUTE_H_