FROM sptrakesh/mongocxx:latest

WORKDIR /app

RUN apk add --no-cache asio-dev

# Copy backend only
COPY CMakeLists.txt .
COPY src ./src
COPY include ./include

# Build
RUN mkdir build && cd build \
 && cmake -DCMAKE_BUILD_TYPE=Release .. \
 && cmake --build . -j$(nproc)

CMD ["./build/green_route"]
