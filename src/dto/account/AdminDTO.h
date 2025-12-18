#include "AccountDTO.h"
class AdminDTO : public AccountDTO {
public:
    AdminDTO(string id, string user, string pass, string name, string phone, string loc)
        : AccountDTO(id, user, pass, name, phone, loc, ADMIN) {}
};