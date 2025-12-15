#ifndef REPORTSERVICE_H
#define REPORTSERVICE_H

#include <vector>
#include "../dto/report/ReportRequestDTO.h"
#include "../dto/report/TeamPerformanceDTO.h"
#include "../dto/report/TrashVolumeDTO.h"
#include "../dal/ReportDAL.h"

class ReportService {
private:
    ReportDAL dal;

public:
    vector<TeamPerformanceDTO> getPerformanceReport(const ReportRequestDTO& req);
    vector<TrashVolumeDTO> getTrashReport(const ReportRequestDTO& req);
};

#endif