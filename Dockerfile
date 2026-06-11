FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    lua5.4 \
    luarocks \
    && rm -rf /var/lib/apt/lists/*

RUN luarocks install luasocket

WORKDIR /app

COPY . .

EXPOSE 8080

CMD ["lua", "server.lua", "0.0.0.0", "8080"]
