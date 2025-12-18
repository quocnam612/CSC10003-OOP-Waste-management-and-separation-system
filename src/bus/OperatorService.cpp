#include "OperatorService.h"
#include <iostream>
#include <iomanip>
#include <algorithm>


OperatorService::OperatorService()
    : currentStatus(ServiceStatus::Pending) {}

OperatorService::~OperatorService() {}

void OperatorService::assignJob(const OperatorDTO& operatorDto, const vector<int>& areas) {
    this->assignedOperator = operatorDto;
    this->assignedAreas = areas;
}

void OperatorService::generateRoute(const CityMap& cityMap) {
    CreateRoute routePlanner(cityMap, assignedAreas);
    auto [cost, route] = routePlanner.generateOptimalRoute();
    this->optimizedRoute = route;
    this->totalDistance = cost;
    this->remainStops = assignedAreas;
    
}

void OperatorService::markStopCompleted(int stopId) {
    completedStops.push_back(stopId);
    remainStops.erase(remove(remainStops.begin(), remainStops.end(), stopId),remainStops.end()
    );

}

Report OperatorService::generateReport() const {
    Report report;
    report.operatorName = assignedOperator.getName();
    report.totalDistance = totalDistance;
    report.numStops = static_cast<int>(completedStops.size());
    report.route = "";
    for (int node : optimizedRoute) {
        report.route += std::to_string(node) + " -> ";
    }
    report.remainStops = static_cast<int>(remainStops.size());
    report.isFinished = (completedStops.size() == assignedAreas.size());
    
    return report;
}

void OperatorService::updateServiceStatus(ServiceStatus status) {
    this->currentStatus = status;
}

void OperatorService::pauseService() {
    if (currentStatus == ServiceStatus::InProgress) {
        currentStatus = ServiceStatus::Pending;
    }
}

void OperatorService::resumeService() {
    if (currentStatus == ServiceStatus::Pending) {
        currentStatus = ServiceStatus::InProgress;
    }
}

ServiceStatus OperatorService::getServiceStatus() const {
    return currentStatus;
}

string OperatorService::getStatus() const {
    switch (currentStatus) {
        case ServiceStatus::Pending:
            return "Pending";
        case ServiceStatus::InProgress:
            return "In Progress";
        case ServiceStatus::Completed:
            return "Completed";
        case ServiceStatus::Cancelled:
            return "Cancelled";
        default:
            return "Unknown";
    }
}

void OperatorService::toReport(Report& report) const {
    cout << "Bao cao :" << endl;
    cout << "Ten nhan vien: " << report.operatorName << endl;
    cout << "Lo trinh: " << report.route << endl;

    cout << "Tong khoang cach: " << report.totalDistance << endl;
    cout << "So khu vuc da hoan thanh: " << report.numStops << endl;
    cout << "So khu vuc con lai: " << report.remainStops << endl;
    cout << "Trang thai hoan thanh: " << (report.isFinished ? "Da hoan thanh" : "Chua hoan thanh") << endl;
}




