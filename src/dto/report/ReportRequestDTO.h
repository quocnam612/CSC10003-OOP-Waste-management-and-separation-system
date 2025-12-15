#ifndef REPORTREQUESTDTO_H
#define REPORTREQUESTDTO_H

#include <string>
using namespace std;

struct ReportRequestDTO {
    string type;       // "time", "trash", "performance"
    string fromDate;
    string toDate;
    string teamId;
};

#endif