FROM gradle:8.6-jdk17 AS build
WORKDIR /app
COPY . .

RUN gradle clean build

FROM openjdk:17-jdk-slim AS runtime

WORKDIR /app

COPY --from=build /app/build/libs/basic_demo-0.1.0.jar /app/app.jar

EXPOSE 59001

CMD ["java", "-cp", "app.jar", "basic_demo.ChatServerApp", "59001"]
