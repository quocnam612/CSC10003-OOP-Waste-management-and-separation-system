# CSC10003-OOP-Waste-management-and-separation-system

## Requirement

* C++23
* Docker
* CMake
* Flutter

## Run & Build API Server

The server will be at  `http://localhost:5000/`

* Docker: just run it

  ```
  docker run --rm -p 5000:5000 green_route
  ```
* Cmake: need to install these requirement goodluck (mongocxx, OPENSSL, asio)

  ```
  cmake --build build
  ```
* Run

  ```
  ./out/greenroute
  ```

## Run & Debug Frontend

You can either go to `src/ui/lib/main.dart` and choose Run/Debug or:

* Run

  ```
  cd src/ui
  flutter run
  ```
