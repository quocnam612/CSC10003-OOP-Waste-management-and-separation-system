#include "bql_menu.h"
#include "team_menu.h"
#include "report_menu.h"
#include "settings_menu.h"
#include <iostream>

void showBQLMainMenu() {
    int c;
    while (true) {
        std::cout << "\n=== BAN QUAN LY ===\n";
        std::cout << "1. Quan li doi don dep\n";
        std::cout << "2. Bao cao thong ke\n";
        std::cout << "3. Cai dat he thong\n";
        std::cout << "0. Thoat\n";
        std::cout << "Chon: ";
        std::cin >> c;

        if (c == 1) showTeamMenu();
        else if (c == 2) showReportMenu();
        else if (c == 3) showSettingsMenu();
        else if (c == 0) break;
    }
}
