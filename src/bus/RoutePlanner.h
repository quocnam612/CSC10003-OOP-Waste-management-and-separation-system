#ifndef _ROUTEPLANNER_H_
#define _ROUTEPLANNER_H_

#include "../dto/CityMap.h"
#include "../utils/graphUtils.h"
#include <vector>

class RoutePlanner {
    protected:
        const CityMap& cityMap;
        vector<int> requiredClean;

        vector<vector<double>> dist;
        vector<vector<vector<int>>> paths;
    public:
        RoutePlanner(const CityMap& map, const vector<int>& requiredCleanNodes);
        void preProcess();
};

#endif // _ROUTEPLANNER_H_