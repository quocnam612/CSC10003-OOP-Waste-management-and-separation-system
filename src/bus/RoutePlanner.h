# ifndef ROUTEPLANNER_H
# define ROUTEPLANNER_H

#include <map>
#include <string>

class RoutePlanner {
private:
    static std::map<std::string,
        std::map<std::string, double>> cityGraph;

public:
    static void addRoute(const std::string& from,
                         const std::string& to,
                         double distance);

    static const std::map<std::string,
        std::map<std::string, double>>& getGraph();
};
# endif