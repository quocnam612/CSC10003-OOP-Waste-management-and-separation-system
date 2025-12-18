#include "CityMap.h"
#include <algorithm>

using std::max;

void CityMap::addEdge(int from, int to, double weight) {
    int maxNode = max(from, to);
    if (maxNode >= adjacencyList.size()) {
        adjacencyList.resize(maxNode + 1);
        numNodes = adjacencyList.size(); 
    }
    adjacencyList[from].push_back({to, weight});
    adjacencyList[to].push_back({from, weight});
    
}

int CityMap::getNumNodes() const {
    return numNodes;
}

const vector<vector<pair<int, double>>>& CityMap::getAdjacencyList() const {
    return adjacencyList;
}