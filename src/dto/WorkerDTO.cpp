#include "WorkerDTO.h"

WorkerDTO::WorkerDTO()
    : AccountDTO(ROLE_WORKER, "", ""),
      name(""), phone(""),
      workerCode(""), workingArea(""),
      shift(""), available(false),
      cityMap() {}

WorkerDTO::WorkerDTO(const AccountDTO& acc)
    : AccountDTO(acc),
      name(""), phone(""),
      workerCode(""), workingArea(""),
      shift(""), available(false),
      cityMap() {}