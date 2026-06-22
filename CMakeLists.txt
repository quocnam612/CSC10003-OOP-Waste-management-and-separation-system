set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

cmake_minimum_required(VERSION 3.16)
project(green_route LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

file(GLOB_RECURSE PROJECT_SOURCES CONFIGURE_DEPENDS
  ${PROJECT_SOURCE_DIR}/src/*.cpp
)

list(FILTER PROJECT_SOURCES EXCLUDE REGEX "${PROJECT_SOURCE_DIR}/src/ui/.*")
list(FILTER PROJECT_SOURCES EXCLUDE REGEX "${PROJECT_SOURCE_DIR}/src/ai/.*")

add_executable(green_route ${PROJECT_SOURCES})

target_include_directories(green_route PRIVATE
  ${PROJECT_SOURCE_DIR}/include
)

list(APPEND CMAKE_PREFIX_PATH
    "/opt/local"
    "/usr/local"
    "/usr"
)

find_package(bsoncxx CONFIG REQUIRED)
find_package(mongocxx CONFIG REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(asio CONFIG)

if(NOT asio_FOUND)
  find_path(ASIO_INCLUDE_DIR
    NAMES asio.hpp asio/asio.hpp
  )
  if(NOT ASIO_INCLUDE_DIR)
    message(FATAL_ERROR "Unable to locate asio.hpp.")
  endif()
endif()

if(TARGET asio::asio)
  target_link_libraries(green_route PRIVATE asio::asio)
elseif(ASIO_INCLUDE_DIR)
  target_include_directories(green_route PRIVATE ${ASIO_INCLUDE_DIR})
endif()

set(BSONCXX_TARGET "")
foreach(t
  bsoncxx::bsoncxx
  mongo::bsoncxx_shared
  mongo::bsoncxx_static
  bsoncxx_shared
  bsoncxx_static
)
  if(TARGET ${t})
    set(BSONCXX_TARGET ${t})
    break()
  endif()
endforeach()

set(MONGOCXX_TARGET "")
foreach(t
  mongocxx::mongocxx
  mongo::mongocxx_shared
  mongo::mongocxx_static
  mongocxx_shared
  mongocxx_static
)
  if(TARGET ${t})
    set(MONGOCXX_TARGET ${t})
    break()
  endif()
endforeach()

if(NOT BSONCXX_TARGET OR NOT MONGOCXX_TARGET)
  message(STATUS "bsoncxx_DIR=${bsoncxx_DIR}")
  message(STATUS "mongocxx_DIR=${mongocxx_DIR}")
  message(FATAL_ERROR "Found bsoncxx/mongocxx packages, but no usable CMake targets were exported.")
endif()

target_link_libraries(green_route PRIVATE
  ${BSONCXX_TARGET}
  ${MONGOCXX_TARGET}
  OpenSSL::Crypto
)
