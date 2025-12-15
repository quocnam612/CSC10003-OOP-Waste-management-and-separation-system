#ifndef TEAMPERFORMANCEDTO_H
#define TEAMPERFORMANCEDTO_H

#include <string>
using namespace std;

struct TeamPerformanceDTO {
    string teamId;
    int totalTasks;
    double avgPerformance;
};

#endif