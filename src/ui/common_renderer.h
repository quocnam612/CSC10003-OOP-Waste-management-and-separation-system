#ifndef COMMON_RENDERER_H
#define COMMON_RENDERER_H

#include <iostream>
#include <string>

struct Renderer {
    static void line() { std::cout << "-----------------------------\n"; }
    static void title(const std::string& t) { line(); std::cout << t << "\n"; line(); }
};

#endif