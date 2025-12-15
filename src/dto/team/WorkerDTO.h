#ifndef WORKERDTO_H
#define WORKERDTO_H

#include <string>
using namespace std;

struct WorkerDTO {
    string id;
    string name;
    string phone;
    string role;
    bool active;
};

#endif