#ifndef AREADTO_H
#define AREADTO_H

#include <string>
#include <vector>
using namespace std;

struct AreaDTO {
    string id;
    string name;
    vector<string> streets;
};

#endif