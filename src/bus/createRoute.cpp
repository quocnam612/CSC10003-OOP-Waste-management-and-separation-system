#include "createRoute.h"

CreateRoute::CreateRoute(const CityMap& map, const vector<int>& requiredCleanNodes)
    : RoutePlanner(map, requiredCleanNodes) {}

pair<double, vector<int>> CreateRoute::generateOptimalRoute() {
    // dist đã là ma trận k × k giữa required nodes
    TSPSolver solver(dist);

    auto [cost, tspOrder] = solver.solve();
    // tspOrder = index trong requiredNodes

    vector<int> fullRoute;

    for (int i = 0; i < tspOrder.size() - 1; i++) {
        int u = tspOrder[i];
        int v = tspOrder[i + 1];

        const auto& p = paths[u][v];
        if (i == 0)
            fullRoute.insert(fullRoute.end(), p.begin(), p.end());
        else
            fullRoute.insert(fullRoute.end(), p.begin() + 1, p.end());
    }

    return {cost, fullRoute};
}