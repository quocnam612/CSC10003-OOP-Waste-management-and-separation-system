cmake_minimum_required(VERSION 3.25)

project(green_route LANGUAGES CXX)

# ===============================
# vcpkg Toolchain (MUST BE FIRST)
# ===============================
set(CMAKE_TOOLCHAIN_FILE "C:/vcpkg/scripts/buildsystems/vcpkg.cmake" CACHE STRING "vcpkg toolchain")

# ===============================
# C++23 Setup
# ===============================
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
add_compile_options(-std=c++23)

# ===============================
# MongoDB Configuration (via vcpkg)
# ===============================
find_package(mongocxx REQUIRED)
find_package(bsoncxx REQUIRED)

# ===============================
# Source files & Executable
# ===============================
file(GLOB_RECURSE project_sources CONFIGURE_DEPENDS "${CMAKE_SOURCE_DIR}/src/*.cpp")
list(FILTER project_sources EXCLUDE REGEX "/src/ui/")

add_executable(green_route ${project_sources})

# ===============================
# Link libraries
# ===============================
target_link_libraries(green_route PRIVATE
    mongocxx::mongocxx
    bsoncxx::bsoncxx
)

# ===============================
# Warnings
# ===============================
if (MSVC)
    target_compile_options(green_route PRIVATE /W4)
else()
    target_compile_options(green_route PRIVATE -Wall -Wextra -pedantic)
endif()

find_package(mongocxx REQUIRED)
find_package(bsoncxx REQUIRED)

target_link_libraries(your_project_name PRIVATE mongocxx::mongocxx bsoncxx::bsoncxx)