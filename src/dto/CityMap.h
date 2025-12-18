#ifndef _CITYMAP_H_
#define _CITYMAP_H_

#include <vector>

using std::vector, std::pair;

class CityMap {
    private:
        vector<vector<pair<int, double>>> adjacencyList;
        int numNodes = 0;
    public:
        void addEdge(int from, int to, double weight);
        int getNumNodes() const;
        const vector<vector<pair<int, double>>>& getAdjacencyList() const;
};


#endif // _MAP_H_