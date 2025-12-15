#include "ReportService.h"

vector<TeamPerformanceDTO> ReportService::getPerformanceReport(const ReportRequestDTO& req) {
    return dal.loadPerformance();  
}

vector<TrashVolumeDTO> ReportService::getTrashReport(const ReportRequestDTO& req) {
    return dal.loadTrashVolume();
}