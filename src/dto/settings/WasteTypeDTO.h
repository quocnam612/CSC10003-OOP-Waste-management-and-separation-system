#include "SettingDTO.h"
class WasteTypeDTO : public SettingDTO {
private:
    double price;
public:
    WasteTypeDTO(string id, string typeName, double price)
        : SettingDTO(id, "Waste Type Config"), price(price) {}
    double getPrice() const { return price; }
};