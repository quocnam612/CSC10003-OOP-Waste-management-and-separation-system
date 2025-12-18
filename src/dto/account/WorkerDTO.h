#include "AccountDTO.h"
class WorkerDTO : public AccountDTO {
private:
    string shift; 
public:
    WorkerDTO(string id, string user, string pass, string name, string phone, string loc, string shift)
        : AccountDTO(id, user, pass, name, phone, loc, WORKER), shift(shift) {}
        
    string getShift() const { return shift; }
};