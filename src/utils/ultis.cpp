#include "ultis.h"

#include <iomanip>
#include <sstream>
#include <ctime>
#include <limits>
#include <math.h>
#include <fstream>
#include <iostream>


using namespace std;


namespace utils {
    void convertToMatrix(const CityMap& map,vector<vector<double>>& matrix) {
        int n = map.getNumNodes();

        matrix.assign(n, vector<double>(
            n, numeric_limits<double>::infinity()));

        const auto& adj = map.getAdjacencyList();
        for (int i = 0; i < n; ++i) {
            for (const auto& [to, w] : adj[i]) {
                matrix[i][to] = w;
            }
        }
    }
    void readMap(const string& filename, CityMap& map) {
        ifstream file(filename);
        if (!file.is_open()) {
            cerr << "Error opening file: " << filename << endl;
            return;
        }
        int from, to;
        double weight;
        while (file >> from >> to >> weight) {
            map.addEdge(from, to, weight);
        }
        file.close();
        cout << "Map loaded from " << filename << endl;
    }

    void readRequiredNodes(const string& filename, vector<int>& nodes) {
        ifstream file(filename);
        if (!file.is_open()) {
            cerr << "Error opening file: " << filename << endl;
            return;
        }
        int node;
        while (file >> node) {
            nodes.push_back(node);
        }
        file.close();
        cout << "Required nodes loaded from " << filename << endl;
    }
}