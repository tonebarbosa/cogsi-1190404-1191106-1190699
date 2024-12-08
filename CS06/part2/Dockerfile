# Stage 1: H2 Database Setup
FROM adoptopenjdk:11-jre-hotspot

ENV H2_ZIP http://www.h2database.com/h2-2019-03-13.zip
ENV H2_PORT 9092
ENV H2_CONSOLE_PORT 8082
ENV H2_DATA /var/lib/h2

RUN apt-get update && apt-get upgrade -y && apt-get install -y unzip && \
    curl ${H2_ZIP} -o h2.zip && unzip -q h2.zip -d /opt/ && rm h2.zip && \
    mkdir ${H2_DATA}

EXPOSE ${H2_PORT} ${H2_CONSOLE_PORT}

WORKDIR ${H2_DATA}

CMD java -cp /opt/h2/bin/h2*.jar org.h2.tools.Server \
    -baseDir ${H2_DATA} -ifNotExists \
    -tcp -tcpAllowOthers -tcpPort ${H2_PORT} \
    -web -webAllowOthers -webPort ${H2_CONSOLE_PORT}


# Stage 2: Deployment
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY ${JAR_PATH} app.jar
COPY ${JAR_PATH_RESOURCES} /app/resources

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
