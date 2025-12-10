#include "crow_all.h"

bool checkLogin(const std::string &user, const std::string &pass)
{
    return (user == "admin" && pass == "123");
}

int main()
{
    crow::SimpleApp app;

    // 1. Trang admin
    CROW_ROUTE(app, "/admin")([](const crow::request &req)
                              {
        if (req.get_header_value("Session") != "OK") {
            return crow::response(302, "Redirect: /login");
        }
        return crow::response("Tải thông tin BQL & Cấu hình hệ thống"); });

    // 2. Trang login
    CROW_ROUTE(app, "/login")([]()
                              { return "<form action='/login' method='post'>User:<input name='u'>Pass:<input name='p'></form>"; });

    // 3. Xử lý login
    CROW_ROUTE(app, "/login").methods("POST"_method)([](const crow::request &req)
                                                     {
        auto user = req.url_params.get("u");
        auto pass = req.url_params.get("p");

        if (user && pass && checkLogin(user, pass)) {
            crow::response res("Đăng nhập thành công");
            res.add_header("Session", "OK");
            return res;
        }
        return crow::response("Sai thông tin, mời nhập lại"); });

    app.port(18080).run();
}