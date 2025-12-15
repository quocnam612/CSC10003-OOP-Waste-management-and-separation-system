#ifndef WORKHISTORYDTO_H
#define WORKHISTORYDTO_H   

#include <string>
using namespace std;

struct WorkHistoryDTO {
    string id;
    string workerId;
    string taskId;
    string date;
    double performance;
    string note;
};

#endif