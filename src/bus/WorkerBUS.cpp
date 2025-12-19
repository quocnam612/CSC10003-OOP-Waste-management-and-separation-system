#include "WorkerBUS.h"
#include <iostream>

std::vector<Task> WorkerBUS::tasks;
ShiftStatus WorkerBUS::shiftStatus = ShiftStatus::OFF;

// UI sends Task → BUS validates & processes → DAL persists
bool WorkerBUS::assignTask(const Task& taskDTO) {
    // Step 1: Validate Task from UI
    // TODO: if (taskDTO.taskId.empty() || taskDTO.location.empty())
    //         return false;
    
    // Step 2: Convert Task to BSON document
    // TODO: bsoncxx::document::value doc = convertTaskToDocument(taskDTO);
    
    // Step 3: Call DAL to persist to DB
    // TODO: if (!WorkerDAL::insert(doc))
    //     return false;
    
    // Step 4: Add to in-memory cache
    tasks.push_back(taskDTO);
    return true;
}

// BUS queries tasks and finds task location
std::string WorkerBUS::findTaskLocation(const std::string& taskId) {
    // TODO: Query from DB instead of in-memory
    for (const auto& t : tasks)
        if (t.taskId == taskId)
            return t.location;
    return "";
}

// BUS calculates shortest path using PathFinder and city map data from DAL
double WorkerBUS::calculateShortestPath(const std::string& from,
                                        const std::string& to) {
    // Use pathfinding algorithm with city map data
    return PathFinder::shortestPath(from, to,
           RoutePlanner::getGraph());
}

// BUS counts completed tasks from DAL
int WorkerBUS::countCompletedTasks() {
    // TODO: Query from DB for completed tasks count
    int cnt = 0;
    for (const auto& t : tasks)
        if (t.completed) cnt++;
    return cnt;
}

// UI sends ShiftStatus → BUS updates → DAL persists
void WorkerBUS::setShiftStatus(ShiftStatus status) {
    shiftStatus = status;
    // TODO: Persist shift status to DB via WorkerDAL
}

ShiftStatus WorkerBUS::getShiftStatus() {
    return shiftStatus;
}

// BUS generates report from data in DAL
void WorkerBUS::generateReport() {
    // Generate report with data from DB
    std::cout << "=== WORKER REPORT ===\n";
    std::cout << "Shift Status: " << (shiftStatus == ShiftStatus::ON ? "ON" : 
                                      shiftStatus == ShiftStatus::PAUSED ? "PAUSED" : "OFF") << "\n";
    std::cout << "Total tasks: " << tasks.size() << "\n";
    std::cout << "Completed tasks: "
              << countCompletedTasks() << "\n";
}