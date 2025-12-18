#include "graphUtils.h"

#include <limits>
#include <algorithm>
#include "ultis.h"
#include <vector>


using namespace utils;
using std::vector, std::pair, std::priority_queue, std::greater;
using std::numeric_limits, std::reverse;


namespace graphUtils {
pair<double, vector<int>>
dijkstra(int start, int end, const CityMap& map) {

    int n = map.getNumNodes();
    const auto& adj = map.getAdjacencyList();

    const double INF = numeric_limits<double>::infinity();

    vector<double> dist(n, INF);
    vector<int> parent(n, -1);

    priority_queue<
        pair<double, int>,
        vector<pair<double, int>>,
        greater<>
    > pq;

    dist[start] = 0.0;
    pq.push({0.0, start});

    while (!pq.empty()) {
        auto [curDist, u] = pq.top();
        pq.pop();

        if (curDist > dist[u]) continue;
        if (u == end) break;   // optimization

        for (const auto& [v, w] : adj[u]) {
            if (dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w;
                parent[v] = u;
                pq.push({dist[v], v});
            }
        }
    }

    // reconstruct path
    vector<int> path;
    if (dist[end] == INF)
        return {INF, path};

    for (int v = end; v != -1; v = parent[v])
        path.push_back(v);

    reverse(path.begin(), path.end());

    return {dist[end], path};
}

    TSPSolver::TSPSolver(const vector<vector<double>>& matrix)
        : adj(matrix), N(matrix.size()),
        finalCost(numeric_limits<double>::infinity()),
        visited(N, false) {}

    double TSPSolver::firstMin(int i) {
        double min = numeric_limits<double>::infinity();
        for (int k = 0; k < N; k++) {
            if (i != k && adj[i][k] < min)
                min = adj[i][k];
        }
        return min;
    }

double TSPSolver::secondMin(int i) {
    double first = numeric_limits<double>::infinity();
    double second = numeric_limits<double>::infinity();

    for (int j = 0; j < N; j++) {
        if (i == j) continue;
        if (adj[i][j] <= first) {
            second = first;
            first = adj[i][j];
        } else if (adj[i][j] < second) {
            second = adj[i][j];
        }
    }
    return second;
}

    void TSPSolver::tspRec(double currBound, double currWeight,
                        int level, vector<int>& currPath) {

        if (level == N) {
            if (adj[currPath[level - 1]][currPath[0]] != numeric_limits<double>::infinity()) {
                double currRes = currWeight +
                    adj[currPath[level - 1]][currPath[0]];

                if (currRes < finalCost) {
                    finalPath = currPath;
                    finalPath.push_back(currPath[0]);
                    finalCost = currRes;
                }
            }
            return;
        }

        for (int i = 0; i < N; i++) {
            if (!visited[i] && adj[currPath[level - 1]][i] != numeric_limits<double>::infinity()) {

                double tempBound = currBound;
                double tempWeight = currWeight;

                currWeight += adj[currPath[level - 1]][i];

                if (level == 1) {
                    currBound -= (firstMin(currPath[level - 1]) + firstMin(i)) / 2;
                } else {
                    currBound -= (secondMin(currPath[level - 1]) + firstMin(i)) / 2;
                }

                if (currBound + currWeight < finalCost) {
                    currPath[level] = i;
                    visited[i] = true;
                    tspRec(currBound, currWeight, level + 1, currPath);
                }

                currWeight = tempWeight;
                currBound = tempBound;
                fill(visited.begin(), visited.end(), false);
                for (int j = 0; j < level; j++)
                    visited[currPath[j]] = true;
            }
        }
    }

    pair<double, vector<int>> TSPSolver::solve() {
        vector<int> currPath(N);
        double currBound = 0;

        for (int i = 0; i < N; i++)
            currBound += (firstMin(i) + secondMin(i));

        currBound = currBound / 2;

        visited[0] = true;
        currPath[0] = 0;

        tspRec(currBound, 0.0, 1, currPath);

        return { finalCost, finalPath };
    }
}