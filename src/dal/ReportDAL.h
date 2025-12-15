#ifndef REPORTDAL_H
#define REPORTDAL_H

#include <vector>
#include "../dto/report/TrashVolumeDTO.h"
#include "../dto/report/TeamPerformanceDTO.h"

class ReportDAL {
public:
    vector<TeamPerformanceDTO> loadPerformance();
    vector<TrashVolumeDTO> loadTrashVolume();
};

#endif