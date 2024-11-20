FROM gradle:8.6-jdk17 AS builder
WORKDIR /app

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

RUN git clone -b feature/cogsi-29 https://github.com/tonebarbosa/cogsi-1190404-1191106-1190699.git .

WORKDIR /app/CS02/tut-rest-gradle/app
RUN gradle build --no-daemon

FROM openjdk:17-jdk-slim
WORKDIR /app

COPY --from=builder /app/CS02/tut-rest-gradle/app/build/libs/*.jar app.jar

COPY --from=builder /app/CS02/tut-rest-gradle/app/src/main/resources /app/resources

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]