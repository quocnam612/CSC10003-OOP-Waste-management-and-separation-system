#ifndef CITYMAP_H
#define CITYMAP_H
#include <string>
#include <vector>
#include <algorithm>
using std::string;
using std::vector;

class CityMap {
private:
    string cityName;
    vector<string> zones;
    vector<string> routes;

public:
    CityMap();
    CityMap(const string& cityName,
            const vector<string>& zones,
            const vector<string>& routes);

    const string& getCityName() const;
    const vector<string>& getZones() const;
    const vector<string>& getRoutes() const;

    void setCityName(const string& value);
    void addZone(const string& zone);
    void addRoute(const string& route);

    bool hasZone(const string& zone) const;
};
#endif