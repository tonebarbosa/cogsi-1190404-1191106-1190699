FROM openjdk:17-jdk-slim

COPY build/libs/basic_demo-0.1.0.jar /app/app.jar
WORKDIR /app

EXPOSE 59001

CMD ["java", "-cp", "app.jar", "basic_demo.ChatServerApp", "59001"]
