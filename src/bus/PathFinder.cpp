#include "PathFinder.h"
#include <queue>
#include <limits>

double PathFinder::shortestPath(
    const std::string& start,
    const std::string& end,
    const std::map<std::string,
    std::map<std::string, double>>& graph) {

    std::map<std::string, double> dist;
    for (const auto& n : graph)
        dist[n.first] = std::numeric_limits<double>::infinity();

    dist[start] = 0;

    using P = std::pair<double, std::string>;
    std::priority_queue<P, std::vector<P>, std::greater<P>> pq;
    pq.push({0, start});

    while (!pq.empty()) {
        auto [d, u] = pq.top(); pq.pop();
        if (u == end) return d;

        for (const auto& [v, w] : graph.at(u)) {
            if (dist[v] > d + w) {
                dist[v] = d + w;
                pq.push({dist[v], v});
            }
        }
    }
    return dist[end];
}