# Tutorial: Como Fazer - CA2

## CA2 - Parte 1

**1. Abrir o terminal, e iniciar o servidor:**

```
java -cp build/libs/basic_demo-0.1.0.jar basic_demo.ChatServerApp 59001
```

**2. Abrir um novo terminal e iniciar o cliente:**

``` 
./gradlew runClient 
```

![alt text](../CA1/images/startClient.png)


**3. Adicionar uma nova tarefa gadle para executar o servidor:
Adiciona-se o seguinte excerto de código ao ficheiro build.gradle.**
``` 
// Task to run the server
task runServer(type: JavaExec) {
    group = "DevOps"
    description = "Launches the Chat Server on port 59001"

    // Set the classpath to include compiled classes and dependencies
    classpath = sourceSets.main.runtimeClasspath

    // Specify the main class for the server
    mainClass = 'basic_demo.ChatServerApp'

    // Pass the server port as an argument
    args '59001'

    // Allows input from the console (useful for stopping the server)
    standardInput = System.in
}
```

- ```type: JavaExec:``` Define que a tarefa é do tipo ```JavaExec```, utilizada para executar uma aplicação Java a partir do Gradle.

- ```group``` e ```description```: Agrupa a tarefa sob "DevOps" e dá uma descrição simples para indicar que esta inicia o servidor na porta 59001.

- ```classpath```: Inclui as classes e dependências compiladas da aplicação, garantindo que o servidor é executado com todos os recursos necessários.

- ```mainClass```: Define a classe principal que contém o método main(), neste caso, a ChatServerApp, responsável por iniciar o servidor.

- ```args```: Passa o número da porta (59001) como argumento, o qual é processado pelo servidor para definir em que porta aceitar conexões.

- ```standardInput```: Permite interação com a consola, útil se precisares de parar o servidor ou introduzir comandos diretamente.

Para executar esta tarefa basta correr no terminal:
````
gradle runServer
````


**4. Para adicionar um teste unitário simples e atualizar o script Gradle para executar o teste, segue-se o passo a passo:**

A secção dependencies no build.gradle define as bibliotecas necessárias para a aplicação e os testes.

````
dependencies {
    // Use Apache Log4J for logging
    implementation group: 'org.apache.logging.log4j', name: 'log4j-api', version: '2.11.2'
    implementation group: 'org.apache.logging.log4j', name: 'log4j-core', version: '2.11.2'

    // Use JUnit 5.7.0 for testing
    testImplementation 'org.junit.jupiter:junit-jupiter-api:5.7.0'
    testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.7.0'
}

Then create a new parameter for test:
test{
    useJUnitPlatform()
    testLogging {
        events "passed", "skipped", "failed"
    }
}
````
- ```implementation```: Define dependências que são necessárias para a aplicação em tempo de execução. Aqui, utilizamos o Log4J (versões 2.11.2 do log4j-api e log4j-core) para logging.

- ```testImplementation```: Define dependências necessárias apenas para os testes. Estamos a utilizar o JUnit 5.7.0 como a framework de testes.

- ```testRuntimeOnly```: Especifica a dependência que será usada apenas durante a execução dos testes, neste caso, o motor de execução do JUnit 

- ```useJUnitPlatform()```: Indica que os testes devem ser executados utilizando a plataforma JUnit 5.

- ```testLogging {}```: Configura os eventos de logging para a execução dos testes. O Gradle vai exibir os testes que passaram, foram ignorados, ou falharam.

Cria um ficheiro de teste em src/test/java/AppTest.java para testar a aplicação. Exemplo de um teste simples:
````
package test.java;

import basic_demo.App;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class AppTest {

    @Test
    public void testApp() {
        App app = new App();
        assertEquals("\nWelcome to \"Multi-User Chat Application\"!\n", app.getGreeting());
    }
}
````
Após configurar as dependências e os testes, podes executá-los com o seguinte comando:
````
./gradlew test --rerun-tasks
````


**5. Para adicionar uma nova tarefa de tipo Copy no Gradle, que faça uma cópia de segurança do conteúdo da pasta src para uma nova pasta de backup, no ficheiro build.gradle:**

````
// Task to back up the sources of the application
task backupSources(type: Copy) {
    group = "Backup"
    description = "Copies the contents of the src folder to a backup folder"

    // Define the source directory to back up
    from 'src'

    // Define the destination directory for the backup
    into "$buildDir/backup"  // This will create a 'backup' folder inside 'build'
}
````

- ```task backupSources```: Introduz uma nova tarefa no script Gradle com o nome ```backupSources```. A adoção de nomes descritivos para as tarefas constitui uma prática recomendável, pois contribui para a manutenção e compreensão do script.

- ```type: Copy```: Indica que a tarefa se classifica como sendo do tipo Copy. Este tipo representa uma tarefa integrada no Gradle destinada à cópia de ficheiros e diretórios. O uso de tipos específicos de tarefas permite tirar partido de funcionalidades já definidas, facilitando assim sua implementação.

- ```group = "Backup"```: Atribui a tarefa ao grupo denominado "Backup". Os grupos ajudam a organizar as tarefas dentro do projeto, especialmente quando este contém múltiplas tarefas com diferentes finalidades. Isso facilita a localização e execução de tarefas relacionadas.

- ```description = "Copies the contents of the src folder to a backup folder"```: Fornece uma descrição detalhada da tarefa. Esta descrição é exibida quando se utiliza comandos como gradle tasks, ajudando os utilizadores a entenderem rapidamente o propósito da tarefa sem precisar examinar o código.

- ```from 'src'```: Define o diretório de origem dos ficheiros a serem copiados. Neste caso, indica que o conteúdo da pasta src (habitualmente onde residem os ficheiros de código-fonte da aplicação) será aquele cuja cópia será efetuada para o destino previamente determinado. O uso de caminhos relativos aumenta a portabilidade do script, possibilitando sua execução em diferentes ambientes sem necessidade de ajustamentos.

- ```into "$buildDir/backup"```: Define o diretório de destino para a cópia dos ficheiros. A variável $buildDir é uma propriedade do Gradle que referencia o diretório de build padrão do projeto. Ao concatenar /backup, especifica-se que a cópia será realizada para uma subpasta denominada backup dentro do diretório de build.

Para executar a tarefa e criar a cópia de segurança dos ficheiros de origem, utiliza o seguinte comando:

````
gradle backupSources
`````

**6. Para adicionar uma nova tarefa de tipo Zip no Gradle, que crie um ficheiro ZIP contendo o backup da aplicação, e garantir que esta tarefa depende da execução da tarefa de backup, segue-se o código necessário:**

No ficheiro build.gradle, adiciona o seguinte bloco de código:

````
// Task to create a zip archive of the backup folder
task zipBackup(type: Zip, dependsOn: backupSources) {
    group = "Backup"
    description = "Creates a zip archive of the backup folder"

    // Define the archive's name and destination
    archiveFileName = "backup.zip"
    destinationDirectory = file("$buildDir")

    // Include the backup folder created by the backupSources task
    from "$buildDir/backup"
}
````
- ```type: Zip```: Define que esta tarefa cria um arquivo ZIP. O Gradle possui uma tarefa pré-definida de tipo Zip, usada para compactar ficheiros e pastas num arquivo .zip.

- ```dependsOn: backupSources```: A tarefa zipBackup depende da execução da tarefa backupSources. Isto significa que, antes de criar o arquivo ZIP, a tarefa de backup será executada, garantindo que os ficheiros que serão arquivados estão atualizados.

- ```group = "Backup"```: Agrupa a tarefa na secção "Backup", facilitando a organização quando listares ou executares as tarefas do projeto.

- ```description = "Creates a zip archive of the backup folder"```: Descreve que esta tarefa cria um arquivo ZIP da pasta de backup. Esta descrição é útil para quando utilizas comandos como gradle tasks, que mostram a lista de tarefas e suas descrições.

- ```archiveFileName = "backup.zip"```: Define o nome do arquivo ZIP a ser criado, que neste caso será "backup.zip".

- ```destinationDirectory = file("$buildDir")```: Define que o ficheiro ZIP será guardado na pasta build, que é o diretório padrão onde o Gradle armazena ficheiros gerados durante o processo de build.

- ```from "$buildDir/backup"```: Especifica a pasta que será incluída no arquivo ZIP. Aqui, o conteúdo da pasta build/backup, que foi criada pela tarefa backupSources, será compactado. Esta linha garante que o arquivo ZIP conterá os ficheiros de backup.

Para criar o arquivo ZIP após o backup, executa-se o seguinte comando:
````
gradle zipBackup
````
**7. Porque é que não foi necessário descarregar e instalar manualmente versões específicas do Gradle e do JDK para compilar e executar esta aplicação?**

O Gradle possui uma funcionalidade designada por "Gradle Wrapper", a qual permite que os desenvolvedores executem um projeto utilizando uma versão específica do Gradle, eliminando a necessidade de realizar uma instalação manual deste. Para tal, são disponibilizados no repositório do projeto scripts de wrapper (gradlew e gradlew.bat).

Estes scripts invocam uma versão do Gradle que se encontra declarada e descarregam automaticamente a versão necessária conforme especificado no projeto. Esta abordagem apresenta diversos benefícios:

Todos os desenvolvedores envolvidos num projeto utilizam a mesma versão do Gradle, o que elimina a necessidade de resolver problemas relacionados com dependências;
Não é requerido efetuar a instalação e gestão manual da versão do Gradle localmente;
Os processos de construção (builds) tornam-se portáteis, permitindo que qualquer pessoa possa clonar o projeto numa máquina diferente e proceder à sua compilação de imediato.
A Gradle Toolchain constitui outra funcionalidade análoga ao Wrapper, sendo responsável por especificar a versão do JDK que deve ser utilizada para compilar e executar o projeto.

Ao integrar ambas as funcionalidades, asseguramos as versões corretas tanto do Gradle como do JDK. Este procedimento proporciona consistência e facilita a utilização, principalmente quando o projeto é implementado em diferentes ambientes.

## CA2 - Parte 2

**1. Converter Building REST services com Spring Application para Gradle (em vez de Maven):**

Criar um novo projeto gradle vazio:

``gradle init
``

```
Type of Build: Application
Implementation Language: Java
Java Version: 17
Project Name: (any name)
Application Structure: Single application project
Build Script DSL: Groovy
Test Framework: JUnit Jupiter
Generate Build using ..: no
```

Agora altera o ficheiro /src dentro do projeto para a implementação que quer utilizar (neste caso vamos utilizar tut-rest/non-rest)

Modifica-se o ficheiro build.gradle e adicionamos as dependências e plugins presentes na implementação que acabámos de adicionar (se houver um ficheiro pom.xml na implementação original é recomendado a sua utilização para saber as suas dependências/plugins).

```
plugins {
    id 'application'
    id 'org.springframework.boot' version '3.0.0'
    id 'io.spring.dependency-management' version '1.1.0'
    id 'java'
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    implementation 'org.springframework.boot:spring-boot-starter-hateoas'

    runtimeOnly 'com.h2database:h2'

    ...
}

```

Não esquecer de alterar a mainClass para a da nova implementação.

```
application {
    mainClass = 'payroll.PayrollApplication'
}
```

Para correr a aplicação:


`./gradlew bootRun`

---

**Custom task that zips the entire source code and stores it in a backup directory.**

```
task backupSources(type: Copy) {
    group = "Backup"
    description = "Copies the contents of the src folder to a backup folder"

    // Define the source directory to back up
    from 'src'

    // Define the destination directory for the backup
    into "backup"  // This will create a 'backup' folder 
}
```

---

**Custom task that depends on the installDist and runs the application using the generated distributed script**

```
task executeDist{
    dependsOn installDist
    description = "Executes the application after it has been installed"

    doLast{
        def os = System.getProperty("os.name").toLowerCase()

        println "Operating System: $os"
        println "Executing the application..."
        if (os.contains("win")) {
            exec {
                commandLine 'cmd', '/c', 'build\\install\\app\\bin\\app.bat'
            }
        } else { 
            exec {
                commandLine 'sh', 'build/install/app/bin/app'
            }
        }
    }
}
```
---

**Create a custom task that depends on the javadoc task, which generates the Javadoc for your project, and then packages the generated documentation into a zip file**

```
task zipJavaDoc(type: Zip) {
    dependsOn javadoc
    description = "Zips the generated JavaDoc"

    // Define the archive name and destination
    archiveFileName = "javadoc.zip"
    destinationDirectory = file("$buildDir/archives")

    // Add the contents of the JavaDoc folder to the archive
    from "$buildDir/docs/javadoc"
}
```