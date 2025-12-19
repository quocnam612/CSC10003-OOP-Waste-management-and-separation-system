#include "CityMap.h"

CityMap::CityMap()
    : cityName(""), zones(), routes() {}

CityMap::CityMap(const string& c,
                 const vector<string>& z,
                 const vector<string>& r)
    : cityName(c), zones(z), routes(r) {}

const string& CityMap::getCityName() const { return cityName; }
const vector<string>& CityMap::getZones() const { return zones; }
const vector<string>& CityMap::getRoutes() const { return routes; }

void CityMap::setCityName(const string& v) { cityName = v; }
void CityMap::addZone(const string& z) { zones.push_back(z); }
void CityMap::addRoute(const string& r) { routes.push_back(r); }

bool CityMap::hasZone(const string& z) const {
    return std::find(zones.begin(), zones.end(), z) != zones.end();
}
