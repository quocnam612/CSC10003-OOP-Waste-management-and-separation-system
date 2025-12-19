#ifndef WORKERDTO_H
#define WORKERDTO_H
#include "AccountDTO.h"
#include "CityMap.h"

class WorkerDTO : public AccountDTO {
public:
    string name;
    string phone;

    string workerCode;
    string workingArea;
    string shift;
    bool available;

    CityMap cityMap;

public:
    WorkerDTO();
    explicit WorkerDTO(const AccountDTO& acc);
};
#endif