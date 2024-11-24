# CA05
In CA5, we’re going to utilize Docker to containerize and deploy our applications. This approach ensures consistency across environments, improves scalability, and simplifies the deployment process. Here’s a guide with justifications for each step taken to setup into a Docker-based solution in CA5.

## Part 1: Building Docker Images for Applications

### Version 1:
````
FROM gradle:8.6-jdk17 AS builder

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN git clone https://github.com/tonebarbosa/cogsi-1190404-1191106-1190699.git .
WORKDIR /app/CS02/
RUN gradle build
 ````

#### Base Image
- Uses gradle:8.6-jdk17 to include the Gradle build system and JDK 17.
- This image is larger because it includes all dependencies needed for building Java projects.

#### Commands:
- Installs git to clone the repository.
- Clones the code repository and builds the application using Gradle.

#### Outcome:
- Creates an image that contains not only the server artifact but also the build tools and source code.
- This is straightforward but less efficient in terms of image size and runtime optimization.

#### Use Case:
- Suitable for a development environment where build portability is prioritized.

### Version 2:
````
FROM openjdk:17-jdk-slim

COPY build/libs/basic_demo-0.1.0.jar /app/app.jar
WORKDIR /app

EXPOSE 59001

CMD ["java", "-cp", "app.jar", "basic_demo.ChatServerApp", "59001"]
````

#### Base Image
- Uses openjdk:17-jdk-slim, a lightweight image with just the JDK, optimized for runtime performance.

#### Commands:
- Copies the pre-built JAR file (basic_demo-0.1.0.jar) into the image.
- Exposes port 59001 for the server to accept client connections.

#### Outcome:
- The resulting image is minimal, containing only the runtime dependencies and the application artifact.
- Does not include build tools, reducing image size and attack surface.

#### Use Case:
- Ideal for production, as the image is smaller and optimized for performance.

## Part 2: Containerized Environment with Docker Compose
- Create a multi-container setup for the Gradle version of the Spring application.
- Establish communication between containers.

### Define Docker Compose File
````
version: '3.8'

services:
  db:
    build: ./db
    container_name: db_service
    image: afbarbosa/db_image:latest
    environment:
      - H2_DATABASE=data/sample
      - H2_USER=admin
      - H2_PASSWORD=pswrd
    volumes:
      - ./db/data:/var/lib/h2
    networks:
      - app-network

  web:
    build: ./web
    container_name: web_service
    image: afbarbosa/web_image:latest
    environment:
      - SPRING_DATASOURCE_URL=jdbc:h2:tcp://db_service:9092/sample
      - SPRING_DATASOURCE_USERNAME=admin
      - SPRING_DATASOURCE_PASSWORD=admin123
    depends_on:
      - db
    ports:
      - "8080:8080"
    networks:
      - app-network
````
Created a docker-compose.yml file with two services:
- web: Hosts the Spring application.
- db: Runs the H2 database server.
Configured the database connection using **SPRING_DATASOURCE_*** variables.

**depends_on** ensures web starts only after db.

### Build and Test the Containers
- Build the images: docker-compose build
- Start the Containers: docker-compose up
- Added healthcheck:
````
healthcheck:
      test: [ "CMD-SHELL", "curl -f http://db_service:8080 || exit 1" ]
      interval: 30s
      timeout: 10s
      retries: 3
````
### Publish Images
Images were tagged and pushed - using António's username (afbarbosa) in this example
````
docker tag afbarbosa/web_image:latest afbarbosa/spring-app:ca5-part2
docker tag afbarbosa/db_image:latest afbarbosa/h2-database:ca5-part2

docker push afbarbosa/web_image:latest
docker push afbarbosa/db_image:latest
````

### Validate Persistent Storage
Restarted the database container and verified the data is still available in the H2 database by querying the database after restarting.
````
docker-compose down
docker-compose up
````

### Summary
This demonstrates the use of Docker Compose to set up a multi-container environment for a Spring application and an H2 database. By leveraging features like service linking and environment variables, the solution ensures seamless communication between the web and db containers while maintaining data persistence. Publishing the images to Docker Hub further enables easy deployment and scalability. This approach highlights Docker Compose's efficiency in managing containerized microservices, making it a practical choice for modern application development.

### Note
We cloned the application from the gradle project beacause docker only can acess subfolders and not "upper" folders. And as it was on CS02/... directories and we were positioned on CS05, it would not work. Therefore, to facilitate this process and after analyzing the two versions made on part1, we've followed the cloning approach.
