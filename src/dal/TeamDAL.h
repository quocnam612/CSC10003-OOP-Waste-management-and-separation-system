#ifndef TEAMDAL_H
#define TEAMDAL_H

#include <vector>
#include "../dto/team/TeamDTO.h"

class TeamDAL {
public:
    vector<TeamDTO> getAllTeams();
    void saveTeams(const vector<TeamDTO>& teams);
};

#endif