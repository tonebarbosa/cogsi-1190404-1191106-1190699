# CA05
In CA5, we’re going to utilize Docker to containerize and deploy our applications. This approach ensures consistency across environments, improves scalability, and simplifies the deployment process. Here’s a guide with justifications for each step taken to setup into a Docker-based solution in CA5.

##Implementing Docker
###Version 1:
````
FROM gradle:8.6-jdk17 AS builder

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN git clone https://github.com/tonebarbosa/cogsi-1190404-1191106-1190699.git .
WORKDIR /app/CS02/
RUN gradle build
 ````

####Base Image
- Uses gradle:8.6-jdk17 to include the Gradle build system and JDK 17.
- This image is larger because it includes all dependencies needed for building Java projects.

#### Commands:
- Installs git to clone the repository.
- Clones the code repository and builds the application using Gradle.

####Outcome:
- Creates an image that contains not only the server artifact but also the build tools and source code.
- This is straightforward but less efficient in terms of image size and runtime optimization.

####Use Case:
- Suitable for a development environment where build portability is prioritized.

###Version 2:
````
FROM openjdk:17-jdk-slim

COPY build/libs/basic_demo-0.1.0.jar /app/app.jar
WORKDIR /app

EXPOSE 59001

CMD ["java", "-cp", "app.jar", "basic_demo.ChatServerApp", "59001"]
````

####Base Image
- Uses openjdk:17-jdk-slim, a lightweight image with just the JDK, optimized for runtime performance.

#### Commands:
- Copies the pre-built JAR file (basic_demo-0.1.0.jar) into the image.
- Exposes port 59001 for the server to accept client connections.

####Outcome:
- The resulting image is minimal, containing only the runtime dependencies and the application artifact.
- Does not include build tools, reducing image size and attack surface.

####Use Case:
- Ideal for production, as the image is smaller and optimized for performance.
