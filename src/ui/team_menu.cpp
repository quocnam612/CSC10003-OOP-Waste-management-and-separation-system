#include "team_menu.h"
#include "../bus/TeamService.h"
#include <iostream>

static TeamService service;

void showTeamMenu() {
    int c;
    while (true) {
        std::cout << "\n--- TEAM MENU ---\n";
        std::cout << "1. Xem danh sach doi\n";
        std::cout << "2. Them doi\n";
        std::cout << "0. Thoat\n";
        std::cout << "Chon: ";
        std::cin >> c;

        if (c == 1) {
            for (auto& t : service.getAll())
                std::cout << "- " << t.id << ": " << t.name << "\n";
        }
        else if (c == 2) {
            TeamDTO t;
            std::cout << "Nhap ID: "; std::cin >> t.id;
            std::cout << "Nhap ten doi: "; std::cin >> t.name;
            service.addTeam(t);
            service.save();
        }
        else if (c == 0) break;
    }
}