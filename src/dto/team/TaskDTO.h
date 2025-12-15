#ifndef TASKDTO_H
#define TASKDTO_H

#include <string>
using namespace std;

struct TaskDTO {
    string id;
    string teamId;
    string areaId;
    string description;
    string dateAssigned;
    string dateCompleted;
    double trashVolume;
};

#endif