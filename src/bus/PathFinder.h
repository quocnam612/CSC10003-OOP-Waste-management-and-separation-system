# ifndef PATHFINDER_H
# define PATHFINDER_H

#include <string>
#include <map>

class PathFinder {
public:
    static double shortestPath(
        const std::string& start,
        const std::string& end,
        const std::map<std::string,
        std::map<std::string, double>>& graph);
};
# endif