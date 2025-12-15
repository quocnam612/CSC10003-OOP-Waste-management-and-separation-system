#ifndef TEAMDTO_H
#define TEAMDTO_H

#include <string>
#include <vector>
#include "MemberDTO.h"
#include "TaskDTO.h"
using namespace std;

struct TeamDTO {
    string id;
    string name;
    vector<MemberDTO> members;
    vector<TaskDTO> tasks;
};

#endif