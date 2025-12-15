#include "settings_menu.h"
#include "../bus/SettingsService.h"
#include <iostream>

static SettingsService ss;

void showSettingsMenu() {
    int c;
    while (true) {
        std::cout << "\n--- SETTINGS MENU ---\n";
        std::cout << "1. Quan li loai rac\n";
        std::cout << "2. Quan li khu vuc\n";
        std::cout << "3. Cau hinh thong bao\n";
        std::cout << "4. Cau hinh email\n";
        std::cout << "0. Thoat\n";
        std::cout << "Chon: ";
        std::cin >> c;

        if (c == 1) {
            auto list = ss.loadTrashTypes();
            std::cout << "Loaded " << list.size() << " trash types\n";
        }
        else if (c == 2) {
            auto list = ss.loadRegions();
            std::cout << "Loaded " << list.size() << " regions\n";
        }
        else if (c == 3) {
            auto c = ss.loadNotificationConfig();
            std::cout << "Notification: " << c.method << "\n";
        }
        else if (c == 4) {
            auto c = ss.loadEmailConfig();
            std::cout << "SMTP: " << c.smtp << "\n";
        }
        else if (c == 0) break;
    }
}