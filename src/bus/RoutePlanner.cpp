#include "RoutePlanner.h"

RoutePlanner::RoutePlanner(const CityMap& map, const vector<int>& requiredCleanNodes)
    : cityMap(map), requiredClean(requiredCleanNodes) {
    int sz = requiredClean.size();
        dist.assign(sz, vector<double>(sz, 0));
        paths.assign(sz, vector<vector<int>>(sz));
    preProcess();
}

void RoutePlanner::preProcess() {
    int sz = requiredClean.size();
    for (int i = 0; i < sz; ++i) {
        for (int j = 0; j < sz; ++j) {
            if (i == j) {
                dist[i][j] = 0;
                paths[i][j] = {requiredClean[i]};
            } else {
                auto [d, path] = graphUtils::dijkstra(requiredClean[i],requiredClean[j],cityMap);
                dist[i][j] = static_cast<int>(d);
                paths[i][j] = path;
            }
        }
    }
}