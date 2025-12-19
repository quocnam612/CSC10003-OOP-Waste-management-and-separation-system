#ifndef WORKERBUS_H
#define WORKERBUS_H

#include <vector>
#include <string>
#include <optional>
#include "PathFinder.h"
#include "RoutePlanner.h"
#include "../dto/WorkerDTO.h"

enum class ShiftStatus { OFF, ON, PAUSED };

struct Task {
    std::string taskId;
    std::string location;
    bool completed = false;
};

class WorkerBUS {
private:
    static std::vector<Task> tasks;
    static ShiftStatus shiftStatus;

public:
    // UI sends Task → BUS validates & processes → DAL persists
    static bool assignTask(const Task& taskDTO);
    
    // BUS queries tasks and finds task location
    static std::string findTaskLocation(const std::string& taskId);
    
    // BUS calculates shortest path using PathFinder and city map data
    static double calculateShortestPath(const std::string& from,
                                        const std::string& to);
    
    // BUS counts completed tasks from DAL
    static int countCompletedTasks();
    
    // UI sends ShiftStatus → BUS updates → DAL persists
    static void setShiftStatus(ShiftStatus status);
    static ShiftStatus getShiftStatus();
    
    // BUS generates report from data in DAL
    static void generateReport();
};
#endif