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

## Alternative Technology

### Podman
Podman is a container management tool designed as a secure, daemonless alternative to Docker. It allows users to build, run, and manage containers without requiring elevated privileges, thanks to its rootless architecture. Podman adheres to the Open Container Initiative (OCI) standards, ensuring compatibility with Docker images and workflows, including Dockerfiles and registries like Docker Hub. Unlike Docker, Podman uses a decentralized approach, running containers as independent processes without relying on a central daemon, which enhances security and resource efficiency. Additionally, Podman supports pods, a concept inspired by Kubernetes, making it an excellent choice for developers working with containerized microservices.

###Advantages of Podman
####Part 1: Building Application Images
- Security: Rootless Operation

Podman does not require a root daemon, which means users can build and run containers without superuser privileges.
This reduces the risk of privilege escalation and makes Podman safer to use on multi-user systems.

- Daemonless Architecture
Podman operates without a central background daemon, avoiding the single point of failure that Docker has. Each container or build runs as an independent process.

- Compatibility with Dockerfiles
Podman uses the same image format and supports Dockerfiles, making migration straightforward without requiring script or process rewrites.

- Smaller Attack Surface
By not running as a root-level daemon, Podman minimizes its attack surface, enhancing security for production systems.
- Performance
Since Podman is daemonless, it can be more lightweight in environments with constrained resources, leading to better performance during builds.

####Part 2: Multi-Container Setup
- Pod Concept for Multi-Container Environments
Podman introduces pods, which group containers in a shared namespace (network, IPC). This simplifies setups where services like web and db must communicate.
Pods align with Kubernetes constructs, enabling easier portability to Kubernetes environments.

- Built-in Kubernetes Support
Podman can generate Kubernetes YAML directly (podman generate kube), streamlining deployment to orchestration platforms compared to Docker Compose.

- Flexibility in Networking
Containers within a pod share networking by default, removing the need for explicit linking or host resolution steps used in Docker Compose.

- Persistent Storage
Podman provides robust volume support similar to Docker, and its rootless nature allows users to manage volumes without requiring elevated privileges.

- Registry Interoperability
Podman supports pushing and pulling images from the same registries as Docker (e.g., Docker Hub, Quay.io), making it straightforward to use Podman-built images in Docker or vice versa.

###Disadvantages of Podman
####Part 1: Building Application Images

- Less Mature Ecosystem
Docker has a more mature ecosystem with extensive community support, documentation, and tooling. Podman, while growing, still lacks the same level of widespread adoption.

- Compatibility Gaps
While Podman supports Dockerfiles, edge cases may arise with more complex Dockerfiles or legacy images that rely on Docker-specific features.

- Learning Curve
Users familiar with Docker may find Podman’s commands slightly different (e.g., podman run vs. docker run), requiring some adaptation.

####Part 2: Multi-Container Setup

- No Native Docker Compose Alternative
Podman lacks a native equivalent to Docker Compose, requiring either:
Manual scripting of pods and containers.
Use of a third-party tool like Podman Compose, which is not as robust or feature-complete as Docker Compose.

- Limited Health Check Support
Podman does not have built-in health checks like Docker’s HEALTHCHECK. Users must rely on external tools or scripts to monitor container health.

- Smaller Community for Complex Use Cases
While Docker Compose is widely used and supported, Podman’s ecosystem for multi-container setups is still developing, which might present challenges for advanced configurations.

- Cross-Platform Availability
Docker is well-supported on Windows, macOS, and Linux. Podman, while available on these platforms, is most robust on Linux. Support on macOS and Windows is still improving but can involve additional setup.
