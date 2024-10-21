# CA2- Part 1

Prerequisites
-------------

* Java JDK 17
* Apache Log4J 2
* Gradle 8.9 (if you do not use the gradle wrapper in the project)


Build
-----

To build a .jar file with the application:

    % ./gradlew build 

Run the server
--------------

Open a terminal and execute the following command from the project's root directory:

    % java -cp build/libs/basic_demo-0.1.0.jar basic_demo.ChatServerApp <server port>

Substitute <server port> by a valid por number, e.g. 59001

Run a client
------------

Open another terminal and execute the following gradle task from the project's root directory:

    % ./gradlew runClient

The above task assumes the chat server's IP is "localhost" and its port is "59001". If you whish to use other parameters please edit the runClient task in the "build.gradle" file in the project's root directory.

To run several clients, you just need to open more terminals and repeat the invocation of the runClient gradle task


Create a Test
---------

First it was added the dependency to the build.gradle file:

    testImplementation 'junit:junit:4.12'

and the following target

    test{
        useJUnit()
    }

Next we created a test class in the following path:
./src/test/java/basic_demo/ChatServerTest.java
You can run the tests using the following commands:

    % ./gradlew test

To see the test output we need to go to the build/reports/tests folder and open the html file

Make source files backup (Copy)
---------------------------

To copy the source file a new backup directory, the task _backup_ was added to the build.gradle file. It can be seen below:

    task backup(type: Copy) {
        group = "DevOps"
        description = "Makes a backup of the sources of the application"
        from 'src'
        into 'backup'
    }

To run this task, open the terminal and type the following command:

    % ./gradlew backup

Zip the backup
---------------------------

To zip the backup, the task zipBackup was added to the build.gradle file. It can be seen below:

    task zipBackup(type: Zip) {
    group = "DevOps"
    description = "Makes a backup of the sources of the application and zips it"
    from 'src'
    archiveFileName = 'backup.zip'
    destinationDirectory = file("backup")
    }

To run this task, open the terminal and type the following command:

    % ./gradlew zipbackup


Why it wasn't necessary to manually download and install specific versions of gradle and JDK
---------------------------

If in the project there is a gradle wrapper, than it is not necessary to download gradle. The java toolchain allows gradle to manage the jdk version required for the project, assuring that every device will use the same JDK.

Running the command that will appear after this will show information about the JDK being used by gradle, helping to verify which JDK configuration is in our project:

    % ./gradlew -q javaToolchain


# CA2- Part 2

Create a Project
----------

- The project was initialized using the command:

> % ./gradlew init

- Options selected during the setup:
    - **Project Type**: Application
    - **Implementation Language**: Java (or your chosen language)
    - **Target Java Version**: 17 (or another target version)
    - **Application Structure**: Single application project
    - **Build Script DSL**: Kotlin (or Groovy)
    - **Test Framework**: JUnit Jupiter

Afterward, we copied the src folder from the non-REST application and replaced the generated one.
To make the application run, we edited the build.gradle file, added the necessary plugins, dependencies, defined the mainClass.

    plugins {
        // Apply the application plugin to add support for building a CLI application in Java.
        id 'org.springframework.boot' version '3.1.0'
        id 'io.spring.dependency-management' version '1.1.0'
        id 'application'
    }
    
    repositories {
        // Use Maven Central for resolving dependencies.
        mavenCentral()
    }
    
    dependencies {
        // JUnit 5 for testing
        testImplementation 'org.junit.jupiter:junit-jupiter-api:5.7.0'
        testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.7.0'
    
        // Spring Boot Starters
        implementation 'org.springframework.boot:spring-boot-starter-web'
        implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    
        // Spring HATEOAS
        implementation 'org.springframework.boot:spring-boot-starter-hateoas'
    
        // H2 database for runtime
        runtimeOnly 'com.h2database:h2'
    }


    // Apply a specific Java toolchain to ease working on different environments.
    java {
        toolchain {
            languageVersion = JavaLanguageVersion.of(17)
        }
    }
    
    application {
        // Define the main class for the application.
        mainClass = 'payroll.PayrollApplication'
    }
    
    test {
        useJUnitPlatform()
    }
    
    jar {
    duplicatesStrategy = DuplicatesStrategy.INCLUDE // allow duplicates
    
        manifest {
            attributes "Main-Class": "payroll.PayrollApplication"
        }
    
        from {
            configurations.runtimeClasspath.collect { it.isDirectory() ? it : zipTree(it) }
        }
    }

This allowed us to use the following command from the plugin 'org.springframework.boot', to run the application
without problem

    % ./gradlew bootRun

to run the testes we used the command:
    
    % ./gradlew test

To see the test output we need to go to the build/reports/tests folder and open the html file


Create a Backup
----------

To create a backup and zip the entire src code we created the task zipBackup

    task zipBackup(type: Zip) {
        group = "DevOps"
        description = "Makes a backup of the sources of the application and zips it"
    
        from 'src'
        archiveFileName = 'backup.zip'
        destinationDirectory = file("backup")
    
    }

Run the Application using scripts generated by installDist task
--------

The installDist task is part of the Gradle Application plugin. It packages your application by generating a
distribution with all the necessary files to run the app, placing them in the build/install directory.

To run the application, we created the runDistApp task, which depends on installDist.
This task works by detecting the operating system and then running the appropriate script
using the commandLine function.

    task runDistApp(type: Exec, dependsOn: installDist) {
        group = "DevOps"
        description = "Runs the application using the distribution scripts generated by installDist"
    
        def os = System.getProperty('os.name').toLowerCase()
        if (os.contains("windows")) {
            commandLine 'cmd', '/c', "build\\install\\${project.name}\\bin\\${project.name}.bat"
        } else {
            commandLine "build/install/${project.name}/bin/${project.name}"
        }
    }

Generate javadoc file
--------

For this task, we created two tasks: javadoc and zipJavadoc. The javadoc task is responsible for generating the Javadoc documentation.
The zipJavadoc task depends on the javadoc task and packages the generated Javadoc into a zip file for easy distribution.

    task zipJavadoc(type: Zip, dependsOn: javadoc) {
        group = "Documentation"
        description = "Generates Javadoc and packages it into a zip file"
    
        from javadoc.destinationDir
        archiveFileName = 'javadoc.zip'
        destinationDirectory = file("$buildDir/docs")
    }
    
    javadoc {
        title = 'Payroll API'
        destinationDir = file("${buildDir}/docs/javadoc")
        source = sourceSets.main.allJava
        options {
            encoding = 'UTF-8'
            charSet = 'UTF-8'
            author = true
            version = true
            windowTitle = 'Payroll API Documentation'
            links("https://docs.oracle.com/javase/8/docs/api/")
        }
    }

Integration Tests
----------
In this project, we set up and configured integration tests alongside unit tests to ensure the proper functioning of the system in a more realistic environment. Here is an overview of what was done to make the integration tests work effectively.

The key to making integration tests work seamlessly lies in the configuration of the build.gradle file. We used the org.unbroken-dome.test-sets plugin, which allows us to define custom test sets, such as integration tests, that can be managed separately from unit tests.

Test Sets Definition: The following plugin was added to define a new set name integrationTest:

    testSets {
        integrationTest
    }

This defines an isolated group of tests that have their own source directories, dependencies, and configurations, making it easier to manage different types of tests (i.e., unit tests vs. integration tests).

Dependencies: Integration tests require specific dependencies, so we extended the unit test configurations (testImplementation and testRuntimeOnly) to the integrationTest configuration. Additionally, we added integration-specific dependencies like WireMock and Spring WebFlux:

    integrationTestImplementation 'org.springframework.boot:spring-boot-starter-test'
    integrationTestImplementation 'com.github.tomakehurst:wiremock:2.27.2'
    integrationTestImplementation 'org.springframework.boot:spring-boot-starter-webflux'

These dependencies allows to mock external services and test reactive web functionalities (like WebClient) in the integration tests.

Source Set Configuration: The sourceSets block was customized for the integration tests, providing separate directories for the test code (src/integrationTest/java) and test resources (src/integrationTest/resources). This isolation ensures that the integration tests do not interfere with the main application or unit tests:

    sourceSets {
        integrationTest {
            java {
                srcDir 'src/integrationTest/java/payroll'
            }
            resources {
                srcDir 'src/integrationTest/resources'
            }
            compileClasspath += sourceSets.main.output + configurations.integrationTestClasspath
            runtimeClasspath += output + compileClasspath
        }
    }

Employee Integration Tests

In the EmployeeIntegrationTest class, we configured the integration tests to run in a Spring Boot context, using real endpoints and WebTestClient to interact with the application.
Key Annotations

    @SpringBootTest: This annotation is used to create a full Spring Boot application context for testing. We specify webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, which spins up the web server on a random port, allowing real HTTP calls to be made against the application during the tests.

    @AutoConfigureWebTestClient: This configures the WebTestClient, a reactive client used to perform web requests in the tests, similar to how a real HTTP client would interact with the API. This client makes it easy to test the web layer of the application by simulating actual HTTP requests and asserting responses.

Example Tests

The integration tests include methods to create, retrieve, and update employee data via HTTP requests. Below are the key methods:

    setup(): Prepares the test by creating sample Employee objects (e.g., Bilbo and Frodo) and storing them in the system using HTTP POST requests.

    testGetEmployeeById(): Sends an HTTP GET request to retrieve an employee by ID and checks if the response matches the expected data.

    testCreateEmployee(): Tests the creation of a new employee by sending an HTTP POST request with the employee data and verifying the response.

    testUpdateEmployee(): Tests updating an existing employee's data by sending an HTTP PUT request and asserting that the updated fields match the expected values.


    @Test
    public void testGetEmployeeById() {
    webClient.get().uri("/employees/" + bilboId)
             .exchange()
             .expectStatus().isOk()
             .expectBody()
             .jsonPath("$.name").isEqualTo("Bilbo Baggins");
    }

    @Test
    public void testCreateEmployee() {
        Employee newEmployee = new Employee("Samwise Gamgee", "gardener", 3, "samwise@email.com");
        webClient.post().uri("/employees")
                .bodyValue(newEmployee)
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.name").isEqualTo("Samwise Gamgee");
    }

    @Test
    public void testUpdateEmployee() {
        Employee updatedEmployee = new Employee("Frodo Baggins", "ring bearer", 5, "frodo2@email.com");
        webClient.put().uri("/employees/" + frodoId)
                .bodyValue(updatedEmployee)
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.role").isEqualTo("ring bearer")
                .jsonPath("$.jobYears").isEqualTo(5);
    }

To successfully run integration tests in this project, you need to follow these steps. Below are the commands and their explanations:

The integrationTest task is responsible for running all integration tests that are part of the custom integrationTest source set. You can run the tests by executing the following command:

    % ./gradlew integrationTest

For more detailed output on the test execution, you can include the --info flag. This provides additional information during the build process:

    % ./gradlew integrationTest --info

If you want to run all tests (both unit and integration tests), you can run the following command:

    % ./gradlew test integrationTest

Before running the integration tests, you can clean up any previous builds by running:

    % ./gradlew clean integrationTest

Gradle allows you to abbreviate task names. For example, instead of typing integrationTest, you can use:

    % ./gradlew iT


Other Gradle commands used
----------
To list all available tasks in your Gradle project, you can use the following command:

    % ./gradlew task

For more detailed information about a specific task during its execution, you can use the following commands:

- To get more information about the task:

  >  % ./gradlew TASK_NAME --info

- To display all warnings during the task's execution:

  > % ./gradlew TASK_NAME --warning-all

To clean the build folder

> % ./gradlew clean



# Alternatives to Gradle

## 1- Ant

### 1.1- What is Ant
Ant (Another Neat Tool) is one of the oldest Java build tools and part of the Apache project. It’s a general-purpose build system used primarily in the Java ecosystem, but it can be adapted for other languages with the right configuration. Ant is script-based and allows developers to write detailed instructions in XML format for compiling code, running tests, packaging applications, and deploying software.

### 1.2- Pros of Ant
- Highly customizable: You can write detailed build scripts for complex workflows.
- Flexible: Allows control over every aspect of the build process.
- Good integration: Well-established in the Java ecosystem, with strong integration with tools like Ivy for dependency management.

### 1.3- Cons of Ant
- Manual configuration: Requires a lot of boilerplate code compared to more modern tools.
- Slow builds: No inherent support for incremental builds or parallel execution, making it slower for large projects.
- Verbose: XML configuration can become lengthy and difficult to manage in large projects.
- No convention: Requires more manual configuration, which can make builds less maintainable and more prone to errors.

## 2- SBT (Simple Build Tool)

### 2.1- What is SBT
SBT is a build tool primarily designed for Scala projects, but it also works with Java and other JVM-based languages. It’s the default build tool for Scala and offers incremental compilation, which speeds up builds by only recompiling the parts of your project that have changed. SBT uses a Scala-based DSL (Domain Specific Language) instead of XML or other formats, making it particularly appealing for Scala developers.

### 2.2- Pros of SBT
- Incremental compilation: SBT supports incremental builds, meaning only changed parts of the code are rebuilt, making the build process faster.
- Scala integration: The tool is designed for Scala projects, with deep language integration and good support for mixed Scala-Java projects.
- Interactive mode: SBT provides a console-based interactive build mode for quicker testing and execution of build commands.
- Plugin ecosystem: It has a rich plugin ecosystem, especially for Scala-related tasks.

### 2.3- Cons of SBT
- Complex configuration: For those unfamiliar with Scala, the configuration DSL can be confusing, especially in large projects.
- Limited beyond Scala: While it works with Java, it’s mainly tailored for Scala, so non-Scala projects might find it lacking.
- Performance issues: Although it supports incremental builds, SBT’s overall performance can lag behind in large projects or complex builds.
- Steep learning curve: The combination of a complex build language (Scala) and the tool's custom DSL can make it difficult to pick up for beginners.

## 3- Bazel

### 3.1- What is Bazel
Bazel is an open-source build tool developed by Google, designed to handle large codebases and polyglot projects. It’s optimized for speed and scalability, with features like parallel execution, incremental builds, and caching. Bazel supports a wide range of languages, including Java, C++, Python, Go, and more, making it a highly flexible tool for teams working on multi-language projects. It’s especially popular in organizations with monorepos, where multiple large projects are managed in a single repository.

### 3.2- Pros of Bazel
- Fast builds: Bazel excels in speed, with features like parallel execution and incremental builds out of the box, making it highly efficient for large projects.
- Language support: It supports multiple languages (Java, C++, Python, Go, etc.), making it suitable for polyglot projects.
- Scalability: Bazel is designed for large codebases, allowing it to scale well and handle complex projects.
- Reproducible builds: Bazel guarantees that builds are hermetic (consistent regardless of environment), which helps avoid the “works on my machine” problem.
- Good for monorepos: It is well-suited for monorepos, where a large number of different projects are stored in the same repository.
- Advanced dependency management: Bazel’s approach to dependencies helps avoid dependency version conflicts and ensures builds are repeatable.

### 3.3- Cons of Bazel
- Steep learning curve: Bazel requires significant initial setup and learning, especially for teams transitioning from other build systems.
- Smaller community: Although growing, the Bazel ecosystem is smaller compared to more traditional tools like Maven or Gradle.
- Custom BUILD files: Bazel uses its own BUILD file syntax, which can be unfamiliar and harder to manage, particularly in the early stages.

## 4- Why We Chose Bazel
- **Speed and Efficiency**: Bazel is significantly faster than both Ant and SBT due to its support for parallel execution, incremental builds, and caching. For large projects, especially those with thousands of files, Bazel's ability to handle incremental changes and parallelize tasks ensures builds are completed faster.
- **Scalability**: While Ant and SBT can handle moderate-sized projects, Bazel is specifically designed for large codebases and monorepos. It excels at managing dependencies and ensuring that builds are efficient, making it ideal for teams with large or complex projects.
- **Language Flexibility**: Unlike Ant (which is focused on Java) and SBT (which is focused on Scala), Bazel supports a wide variety of languages (Java, C++, Go, Python, etc.), making it the better option for polyglot environments or teams working across different programming languages.
- **Reproducibility**: Bazel guarantees reproducible builds, meaning the same build command will produce the exact same output on any machine, which is crucial for large teams and CI/CD environments. Neither Ant nor SBT offer this level of hermeticity.
- **Future-Proof**: Bazel is rapidly growing in popularity, especially in companies with large codebases and strict performance needs (e.g., Google, Uber). Its focus on fast, correct, and scalable builds makes it more future-proof compared to older tools like Ant.

## 5- Bazel vs Gradle

### 5.1 - Performance

#### 5.1.1 - Gradle
- **Incremental builds**: Gradle supports incremental builds, which means only changed parts of the code are rebuilt. This helps significantly with performance, especially in large projects.
- **Daemon process**: Gradle uses a build daemon to keep a process running in the background, making subsequent builds faster.
- **Caching**: Gradle supports local and remote caching of build outputs, which can drastically improve build performance when there are no changes.

#### 5.1.2 - Bazel
- **Parallel execution**: Bazel is designed from the ground up to parallelize tasks, which can dramatically speed up build times, especially in multi-core environments.
- **Incremental builds**: Bazel also supports incremental builds and does this in an extremely efficient way, ensuring that only the necessary parts of a project are rebuilt.
- **Distributed builds**: Bazel is optimized for distributed build environments, making it much faster for large teams working on large projects, as build tasks can be spread across multiple machines.

#### 5.1.3 - Winner
Bazel generally outperforms Gradle in very large, multi-language projects due to its superior parallelism and support for distributed builds. However, for JVM-based projects like Android and Java, Gradle's performance is highly optimized and often sufficient.

### 5.2 - Ease of Use and Learning Curve

#### 5.2.1 - Gradle
- **Ease of use**: Gradle is widely regarded as easier to set up and use, especially for JVM-based projects. Developers familiar with Groovy or Kotlin will find the DSL (Domain Specific Language) easy to work with.
- **Extensibility**: It’s highly customizable, with an extensive plugin ecosystem that makes adding new tasks, dependencies, or languages relatively simple.
- **Community**: Gradle has a large community and plenty of documentation, tutorials, and tools, making it more approachable for new users.

#### 5.2.2 - Bazel
- **Learning curve**: Bazel is more complex to configure, and its BUILD files (written in its custom syntax) can be harder to manage, especially for teams transitioning from other tools like Gradle or Maven.
- **Setup**: Bazel requires more upfront configuration to set up its hermetic build environment, which can be a challenge for smaller teams or projects that don’t need extreme performance optimization.
- **Less intuitive**: Its focus on scalability and reproducibility adds complexity, which makes it less intuitive compared to Gradle’s more flexible scripting model.

#### 5.2.3 - Winner
Gradle is easier to pick up, especially for developers working with JVM and Android ecosystems. Bazel requires more setup and has a steeper learning curve.

### 5.3 - Build Configuration and Extensibility

#### 5.3.1 - Gradle
- **Build scripts**: Gradle build scripts can be written in either Groovy or Kotlin DSL, offering flexibility and readability. The use of a scripting language means you can add complex logic directly into your build file.
- **Plugin ecosystem**: Gradle has a rich ecosystem of plugins for Java, Android, Spring, and more. This makes extending Gradle to fit specific project needs relatively straightforward.
- **Customizability**: Gradle’s scripting model allows developers to create complex, customized build logic without needing to adhere strictly to conventions.

#### 5.3.2 - Bazel
- **BUILD files**: Bazel uses a custom Starlark language for its BUILD and WORKSPACE files. These files are more declarative than Gradle’s scripts, which makes them more predictable but harder to extend with complex logic.
- **Limited plugin ecosystem**: Bazel has fewer plugins compared to Gradle, as it focuses more on performance and scalability than flexibility. However, it can still be extended through custom rules.

#### 5.3.3 - Winner
Gradle offers more flexibility and ease of customization with its DSL-based configuration.

### 5.4 - When to Choose Gradle
- You’re working on **Java, Kotlin, or Android** projects.
- You need a flexible, easy-to-use build system with strong dependency management.
- You value extensive plugin support and don’t need extreme performance.

### 5.5 - When to Choose Bazel
- You have a large codebase or work in a **polyglot environment**.
- You prioritize **speed**, **scalability**, and **reproducible builds** across different environments.
- You need to handle complex, **distributed builds** efficiently.


# Implementation Alternative solution - Bazel

Create the project
-----

To create the project first we added the files WORKSPACE.bazel,
BUILD.bazel, MODULE.bazel, .bazelversion, .bazelrc to the project root

The WORKSPACE.bazel is an empty file that acts as a marker for Bazel to recognize the directory as
the workspace root of the project. It allows Bazel to locate the necessary build files and
dependencies within the project and sets the context for the build system to operate from
that root directory.

The BUILD.bazel file defines the build rules and targets for the project.
It provides instructions on how to build various components, such as libraries, binaries, or tests.
Each BUILD.bazel file corresponds to a specific directory within the project, specifying how Bazel should compile, link, and package the code in that directory.
The targets defined in the BUILD.bazel file can be referenced when running Bazel commands to build, test, or generate outputs.
In this case, we used a single BUILD.bazel file at the project root due to the program's low complexity.

    load("@rules_java//java:defs.bzl", "java_binary", "java_library", "java_test")
    
    package(default_visibility = ["//visibility:public"])
    
    java_library(
        name = "java_lib",
        srcs = glob(["src/main/java/payroll/*.java"]),
        deps = [
            "@maven//:org_springframework_boot_spring_boot_starter_web",
            "@maven//:org_springframework_boot_spring_boot_starter_data_jpa",
            "@maven//:org_springframework_boot_spring_boot_starter_hateoas",
            "@maven//:jakarta_persistence_jakarta_persistence_api",
            "@maven//:org_slf4j_slf4j_api",
            "@maven//:org_springframework_boot_spring_boot",
            "@maven//:org_springframework_boot_spring_boot_autoconfigure",
            "@maven//:org_springframework_data_spring_data_jpa",
            "@maven//:org_springframework_hateoas_spring_hateoas",
            "@maven//:org_springframework_spring_context",
            "@maven//:org_springframework_spring_web",
            "@maven//:com_h2database_h2",
        ],
    )
    
    java_binary(
        name = "rest",
        main_class = "payroll.PayrollApplication",
        runtime_deps = [
            ":java_lib",
        ],
    )
    
    java_test(
        name = "rest_test",
        srcs = glob(["src/test/java/payroll/*.java"]),
        test_class = "payroll.EmployeeTest",
        deps = [
            ":java_lib",
            "@maven//:junit_junit",
        ],
    )


The MODULE.bazel is a file that defines the external dependencies and module structure for Bazel's module system.
It allows Bazel to fetch and integrate external libraries or tools needed for the project, ensuring proper versioning and dependency management.

    bazel_dep(name = "rules_jvm_external", version = "6.4")
    
    
    maven = use_extension("@rules_jvm_external//:extensions.bzl", "maven")
    maven.install(
        artifacts = [
            "org.springframework.boot:spring-boot-starter-web:3.2.0",
            "org.springframework.boot:spring-boot-starter-data-jpa:3.2.0",
            "org.springframework.boot:spring-boot-starter-hateoas:3.2.0",
            "com.h2database:h2:2.2.224",
            "junit:junit:4.12.0",
        ],
            fetch_sources = True,
            repositories = [
            "https://repo1.maven.org/maven2",
            "http://uk.maven.org/maven2",
            "https://jcenter.bintray.com/",
            "https://maven.google.com",
        ],
    )
    
    use_repo(maven, "maven")


The .bazelversion file specifies the version of Bazel that should be used for the project.

    7.3.2

The .bazelrc file is a configuration file that contains user-specific or project-specific settings for Bazel.
It allows you to customize the behavior of Bazel by defining flags and options that should be applied by default when running Bazel commands.

    common --enable_bzlmod

### Commands

To build the project we use the command:

    % bazel build :rest

To run the project we use the command:

    % bazel run :rest

To run the test we use

    % bazel test :rest_test

Generate a backup and zip
------

For this task we added the following dependencies in WORKSPACE.bazel:

    load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
    http_archive(
        name = "rules_pkg",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.9.1/rules_pkg-0.9.1.tar.gz",
            "https://github.com/bazelbuild/rules_pkg/releases/download/0.9.1/rules_pkg-0.9.1.tar.gz",
        ],
        sha256 = "8f9ee2dc10c1ae514ee599a8b42ed99fa262b757058f65ad3c384289ff70c4b8",
        )
    load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
    rules_pkg_dependencies()

Also added the following dependencies and targets to BUILD.bazel:

- Dependencies

        load("@rules_pkg//:pkg.bzl", "pkg_zip")
        load("@rules_pkg//:mappings.bzl", "pkg_files", "strip_prefix")

- Targets

        pkg_files(
        name = "src_files",
        srcs = glob([
        "src/**",
        ]),
        strip_prefix = strip_prefix.from_pkg(),
        )
    
        pkg_zip(
            name = "backup",
            srcs = [":src_files"],
        )

### Commands

To run the zip and backup, we use the command

    % bazle build :backup

Generate Distribution Script
------

Due to the steep learning curve of bazel, this could not be implemented.
Despite this, the task should be doable by using external bazel rules or by creating your own.
We didn't find any external rules for this and didn't have neither the knowledge nor the by time to implement a rule by ourselves.

Generate Javadoc
------

There is no official Javadoc rule.
Although we found some unofficial rules, these either did not work as expected or stopped working due to a lack of maintenance or documentation that made implementation difficult.
This led us to give up implementing this task, but we leave the link to some of the found rules for anyone who wants to try to implement or explore:

- https://github.com/google/bazel-common/blob/master/tools/javadoc/javadoc.bzl
- https://gist.github.com/kchodorow/e5225e2e266013b88c0c
- https://github.com/pubref/rules_apidoc/blob/master/java/README.md#javadoc
- https://gerrit.googlesource.com/gerrit/+/master/tools/bzl/javadoc.bzl
- https://github.com/google/bazel-common/tree/master/tools/javadoc
- https://github.com/bazel-contrib/rules_jvm_external/blob/master/docs/api.md#javadoc

"Source Sets" for Integration Tests
-------

There are no Source Sets on bazel. 
Instead bazel uses a path to the source files on the rules defined on BUILD.gradle. 
To build the integration tests on bazel, it is only required to import the necessary dependencies on the MODULE.bazel 
and create a "java_test" target with the correct path to the source files:

- MODULE.bazel:
      
      bazel_dep(name = "rules_jvm_external", version = "6.4")
      
      maven = use_extension("@rules_jvm_external//:extensions.bzl", "maven")
      maven.install(
      artifacts = [
      "org.springframework.boot:spring-boot-starter-web:3.2.0",
      "org.springframework.boot:spring-boot-starter-data-jpa:3.2.0",
      "org.springframework.boot:spring-boot-starter-hateoas:3.2.0",
      "org.springframework.boot:spring-boot-starter-webflux:3.3.4",
      "org.springframework.boot:spring-boot-starter-test:3.3.4",
      "org.springframework.boot:spring-boot-test-autoconfigure:3.3.4",
      "org.springframework:spring-beans:5.3.25",
      "com.github.tomakehurst:wiremock:2.27.2",
      "com.h2database:h2:2.2.224",
      "junit:junit:4.13.2",
      ],
      fetch_sources = True,
      repositories = [
      "https://repo1.maven.org/maven2",
      "http://uk.maven.org/maven2",
      "https://jcenter.bintray.com/",
      "https://maven.google.com",
      ],
      )
      
      use_repo(maven, "maven")

- BUILD.bazel

      java_test(
      name = "integration_test",
      srcs = glob(["src/integrationTest/java/payroll/*.java"]),
      test_class = "payroll.EmployeeIntegrationTest",
      deps = [
       ":java_lib",
      "@maven//:junit_junit",
      "@maven//:org_springframework_spring_beans",
      "@maven//:org_springframework_boot_spring_boot",
      "@maven//:org_springframework_boot_spring_boot_test",
      "@maven//:org_springframework_boot_spring_boot_starter_webflux",
      "@maven//:org_springframework_boot_spring_boot_test_autoconfigure",
      "@maven//:org_springframework_spring_test",
      "@maven//:com_github_tomakehurst_wiremock",
      ]
      )

**Note**: Bazel is limited to Junit 4 for testing, which makes it limited in terms of coding.

### Commands

To run this new target, we can run the following command:
 
    % bazel test :integration_test