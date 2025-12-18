#include "createRoute.h"
#include "RoutePlanner.h"
#include "../dto/OperatorDto.h"

enum class ServiceStatus {
    Pending,    // Dang cho
    InProgress, // Dang tien hanh
    Completed,  // Hoan thanh
    Cancelled   // Da huy
};

struct Report {
    string operatorName;
    double totalDistance;
    int numStops;
    int remainStops;
    string route;
    bool isFinished;
};

class OperatorService {
private:
    vector<int> assignedAreas;
    vector<int> optimizedRoute;
    vector<int> remainStops;
    vector<int> completedStops;
    double totalDistance;

    ServiceStatus currentStatus;
    OperatorDTO assignedOperator;
public:
    OperatorService();
    ~OperatorService();
public:
    void assignJob(const OperatorDTO& operatorDto, const vector<int>& areas);
    void generateRoute(const CityMap& cityMap);
    void markStopCompleted(int stopId);
    Report generateReport() const;
    void updateServiceStatus(ServiceStatus status);
    void pauseService();
    void resumeService();
    ServiceStatus getServiceStatus() const;
    string getStatus() const;
    void toReport(Report& report) const;

};