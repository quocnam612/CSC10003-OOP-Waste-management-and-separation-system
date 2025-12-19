#include "RoutePlanner.h"

std::map<std::string,
    std::map<std::string, double>> RoutePlanner::cityGraph;

void RoutePlanner::addRoute(const std::string& from,
                            const std::string& to,
                            double distance) {
    cityGraph[from][to] = distance;
    cityGraph[to][from] = distance; // 2 chiều
}

const std::map<std::string,
    std::map<std::string, double>>&
RoutePlanner::getGraph() {
    return cityGraph;
}