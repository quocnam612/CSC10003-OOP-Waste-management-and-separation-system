#include "../utils/ultis.h"
#include "../dto/CityMap.h"
#include "../utils/graphUtils.h"
#include "../bus/RoutePlanner.h"
#include "../bus/createRoute.h"
#include "../dto/OperatorDto.h"
#include "../bus/OperatorService.h"
#include <iostream>


using namespace graphUtils;
using namespace utils;
using namespace std;

int main() {
    string mapInput ="CityMap.txt";
    string requiredNodesInput ="requiredNodes.txt";
    CityMap map;
    readMap(mapInput, map);
    vector<int> requiredNodes;
    readRequiredNodes(requiredNodesInput, requiredNodes);
    OperatorDTO operatorDto("John Doe", "johndoe", "hashed_password", "123-456-7890");
    OperatorService service;
    service.assignJob(operatorDto, requiredNodes);
    service.generateRoute(map);
    // bat dau di chuyen den cac diem
    auto report = service.generateReport();
    service.toReport(report);

    // khi di qua 3 diem
    service.markStopCompleted(requiredNodes[0]);
    service.markStopCompleted(requiredNodes[1]);
    service.markStopCompleted(requiredNodes[2]);
    report = service.generateReport();
    service.toReport(report);

    // khi di qua het cac diem con lai
    service.markStopCompleted(requiredNodes[3]);
    service.markStopCompleted(requiredNodes[4]);
    service.markStopCompleted(requiredNodes[5]);
    report = service.generateReport();
    service.toReport(report);



    return 0;
}