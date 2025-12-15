#ifndef TEAMSERVICE_H
#define TEAMSERVICE_H

#include <vector>
#include "../dto/team/TeamDTO.h"
#include "../dal/TeamDAL.h"

class TeamService {
private:
    TeamDAL dal;
    vector<TeamDTO> cache;

public:
    TeamService();
    vector<TeamDTO> getAll();
    void addTeam(const TeamDTO& t);
    void save();
};

#endif