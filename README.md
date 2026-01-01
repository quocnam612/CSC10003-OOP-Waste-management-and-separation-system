# CSC10003-OOP-Waste-management-and-separation-system

## Requirement

* C++23
* Docker
* CMake
* Flutter

## Run the app WITHOUT API server

I've already host it on render at [csc10003-oop-waste-management-and.onrender.com](csc10003-oop-waste-management-and.onrender.com).
You can check with [csc10003-oop-waste-management-and.onrender.com/health](csc10003-oop-waste-management-and.onrender.com/health)

```
  cd src/ui
  flutter run --dart-define=API_URL=https://csc10003-oop-waste-management-and.onrender.com
```

or build it into an actual program with:

* Linux:

  ```
  cd src/ui
  flutter build linux --release --dart-define=API_URL=https://csc10003-oop-waste-management-and.onrender.com
  ```
* Windows:

  ```
  cd src/ui
  flutter build windows --release --dart-define=API_URL=https://csc10003-oop-waste-management-and.onrender.com
  ```

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
