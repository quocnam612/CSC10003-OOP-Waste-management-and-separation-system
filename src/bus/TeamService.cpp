#include "TeamService.h"

TeamService::TeamService() {
    cache = dal.getAllTeams();
}

vector<TeamDTO> TeamService::getAll() {
    return cache;
}

void TeamService::addTeam(const TeamDTO& t) {
    cache.push_back(t);
}

void TeamService::save() {
    dal.saveTeams(cache);
}
