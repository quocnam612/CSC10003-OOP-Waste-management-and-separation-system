#ifndef REGIONDTO_H
#define REGIONDTO_H

#include <string>
#include <vector>
using namespace std;

struct RegionDTO {
    string id;
    string name;
    vector<string> streets;
};

#endif