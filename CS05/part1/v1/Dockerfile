FROM gradle:8.6-jdk17 AS builder

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN git clone https://github.com/tonebarbosa/cogsi-1190404-1191106-1190699.git .
WORKDIR /app/CS02/
RUN gradle build

CMD ["gradle", "runServer"]
