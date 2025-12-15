#include "report_menu.h"
#include "../bus/ReportService.h"
#include <iostream>

static ReportService rs;

void showReportMenu() {
    int c;
    while (true) {
        std::cout << "\n--- REPORT MENU ---\n";
        std::cout << "1. Bao cao hieu suat\n";
        std::cout << "2. Bao cao khoi luong rac\n";
        std::cout << "0. Thoat\n";
        std::cout << "Chon: ";
        std::cin >> c;

        if (c == 1) {
            auto list = rs.getPerformanceReport({"performance"});
            std::cout << "Loaded " << list.size() << " records\n";
        }
        else if (c == 2) {
            auto list = rs.getTrashReport({"trash"});
            std::cout << "Loaded " << list.size() << " records\n";
        }
        else if (c == 0) break;
    }
}