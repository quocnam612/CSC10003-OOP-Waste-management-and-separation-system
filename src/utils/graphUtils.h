#ifndef _GRAPHUTILS_H_
#define _GRAPHUTILS_H_

#include <vector>
#include <queue>
#include <limits>
#include "../dto/CityMap.h"
#include <math.h>

using std::vector,std::pair;

namespace graphUtils {
    // Function to perform BFS on a graph
    pair<double, vector<int>> dijkstra(int startNode, int endNode, const class CityMap& map);
    
    class TSPSolver {
    private:
        int N;
        std::vector<std::vector<double>> adj;
        std::vector<int> finalPath;
        std::vector<bool> visited;
        double finalCost;

        double firstMin(int i);
        double secondMin(int i);
        void tspRec(double currBound, double currWeight, int level,
                    std::vector<int>& currPath);

    public:
        TSPSolver(const std::vector<std::vector<double>>& matrix);
        std::pair<double, std::vector<int>> solve();
    };

}

#endif // _GRAPHUTILS_H_