# Apache Ant como uma alternativa ao Gradle

O **Apache Ant** é uma ferramenta de automação de processos de compilação, muito utilizada em projetos Java. O mesmo, facilita tarefas como compilar código, gerar pacotes e executar testes, permitindo que programadores automatizem estas etapas de forma eficiente. Baseado em arquivos XML para configurar os processos, a ferramenta Ant é multiplataforma e flexível, podendo ser adaptado para diferentes projetos. Embora tenha perdido popularidade para outras ferramentas mais modernas, como Maven e Gradle, o Ant ainda é amplamente utilizado, especialmente em projetos que não precisam de gestão avançada de dependências.


Algumas empresas e projetos conhecidos que já utilizaram ou ainda utilizam Apache Ant incluem:

- IBM (Utilizado na automatização de tarefas no ambiente de desenvolvimento)
- BlackRock (Utilizado na automatização de XXXXX)
- Red Hat (Utilizado na automatização de processos de desenvolvimento de Software, principalmente nos de código Open Source)

-----------------------------------------------------------------

## Características principais:

 - **Baseado em XML**: O Ant utiliza arquivos XML para descrever o processo de build, chamados de "build.xml". Esses arquivos especificam tarefas, como compilar o código-fonte, empacotar em JARs, executar testes, entre outras atividades de automação. XXXXXXXX

 - **Orientado a tarefas**: Ao contrário de ferramentas como Make, que se baseiam em um modelo de dependências, o Apache Ant é **orientado a tarefas**, permitindo que os desenvolvedores definam explicitamente a sequência de etapas do processo de build. Isso proporciona maior controle e flexibilidade, pois os usuários podem organizar as tarefas conforme necessário, sem a complexidade da resolução automática de dependências.

 - **Independência de plataforma**: Como é escrito em Java, o Ant pode ser executado em qualquer sistema operacional que tenha uma JVM (Java Virtual Machine), o que o torna multiplataforma.

 - **Extensiblidade**: Permite a criação de tarefas personalizadas em Java, além das várias tarefas pré-definidas que ele oferece. Isso torna o Ant altamente adaptável, permitindo que desenvolvedores implementem soluções específicas para suas necessidades de build. Essa flexibilidade é essencial em projetos que requerem integração com ferramentas externas ou processos complexos, garantindo que o Ant possa evoluir junto com os requisitos dos sistemas​.

-------------------------------------------------------------------


## Comparação Apache Ant vs Gradle

| Característica              | Apache Ant                                   | Gradle                                             |
|-----------------------------|----------------------------------------------|----------------------------------------------------|
| **Ano de Lançamento**        | 2000                                         | 2009                                               |
| **Paradigma de Build**       | Baseado em tarefas (task-based)              | Orientado a tarefas e dependências                 |
| **Arquivo de Configuração**  | XML                                          | Groovy ou Kotlin (DSLs concisos)                   |
| **Curva de Aprendizado**     | Moderada (devido ao uso de XML)              | Maior inicialmente, mas mais simples para tarefas complexas |
| **Extensibilidade**          | Scriptável com lógica em XML                 | Altamente extensível com plugins e suporte a linguagens de script |
| **Suporte a Dependências**   | Não nativo, usa Ivy ou outros                | Nativo, integrado ao Maven e Ivy                   |
| **Velocidade**               | Mais lenta em builds complexos               | Incremental, mais rápido em projetos maiores        |
| **Modularidade**             | Suporte mais limitado                        | Melhor suporte para projetos modulares              |
| **Ecossistema**              | Menor quantidade de plugins                  | Ecossistema mais moderno e rico de plugins          |
| **Integração com IDEs**      | Suporte adequado                             | Excelente integração com IDEs como IntelliJ e Eclipse |
| **Compatibilidade**          | Melhor compatibilidade com sistemas legados  | Voltado para projetos mais modernos                 |


Alguns benefícios do Apache Ant em comparação ao Gradle, com foco nos cenários em que o Ant pode ser uma escolha vantajosa:

 ## 1. Controle Granular do Processo de Build
- O Ant oferece controle total sobre cada etapa do processo de build. No Ant, você define explicitamente o que acontece em cada fase, o que pode ser vantajoso em casos onde você precisa de personalização máxima e controle detalhado.
- O Gradle abstrai muitas dessas operações, o que é útil na maioria dos casos, mas pode limitar a flexibilidade em builds altamente customizados.
 ## 2. Simplicidade para Projetos Pequenos ou Legados
- O Ant é uma ferramenta simples para projetos pequenos ou sistemas legados. Ele não exige o aprendizado de uma linguagem de script, como Groovy ou Kotlin (necessárias no Gradle), o que pode ser útil para desenvolvedores com menos experiência em linguagens de programação modernas.
- Para projetos antigos, que já utilizam Ant, não há necessidade de migração para ferramentas mais complexas, economizando tempo e esforço.
## 3. Sem Convenções Rígidas
- Diferente do Gradle (e do Maven), que seguem o princípio de "convenção sobre configuração", o Ant não impõe convenções rígidas de estrutura de diretórios ou ciclo de vida de builds. Isso é vantajoso em projetos que possuem uma organização de arquivos fora dos padrões, permitindo que o desenvolvedor tenha liberdade total para definir o fluxo de build.
## 4. Leveza e Simplicidade
- O Ant é mais leve e simples de configurar, já que não carrega a sobrecarga de um sistema de gestão de dependências embutido como o Gradle. Isso pode ser útil em projetos onde você não precisa de uma gestão complexa de dependências ou em ambientes onde a simplicidade é preferida.
## 5. Ampla Adoção em Projetos Legados
- O Ant é amplamente utilizado em muitos sistemas antigos. Se você está trabalhando em um projeto legado que já utiliza o Ant, mantê-lo pode ser mais vantajoso do que migrar para o Gradle, especialmente se a equipe de desenvolvimento já estiver familiarizada com a ferramenta.
## 6. Flexibilidade para Estruturas Não-Convencionais
- Como o Ant não segue convenções específicas de estrutura de projeto, ele é mais adequado para projetos com estruturas não convencionais ou sistemas mais complexos, onde as ferramentas que seguem convenções podem ser menos flexíveis.
- O Gradle pode ser configurado para suportar essas estruturas, mas isso exige mais personalização e entendimento do sistema.
## 7. Execução de Tarefas de Forma Isolada
- O Ant permite que você defina e execute tarefas de maneira completamente independente. Embora o Gradle também ofereça flexibilidade nas tarefas, ele geralmente lida com elas em um contexto mais dependente de outras tarefas e fases do build.
## 8. Simplicidade de Integração com Ferramentas Personalizadas
- O Ant pode ser facilmente integrado com scripts de shell, arquivos batch ou outras ferramentas personalizadas, o que o torna uma escolha flexível em ambientes onde a automação envolve várias tecnologias externas que precisam ser gerenciadas de maneira explícita.
## 9. Menor Curva de Aprendizado para Desenvolvedores Sem Experiência com DSLs
- O Ant é baseado em XML, uma tecnologia amplamente conhecida e que não requer o aprendizado de novas linguagens de script. Isso pode ser uma vantagem em equipes onde os desenvolvedores estão menos familiarizados com Groovy, Kotlin ou outras DSLs (usadas pelo Gradle), facilitando a adoção da ferramenta.
## 10. Independência de Sistemas de Dependência
- O Ant não depende de um gerenciador de dependências integrado como o Gradle. Isso pode ser vantajoso em ambientes onde há requisitos estritos de controle de dependências, ou onde a dependência de repositórios externos não é desejável.

-------------------------------------------------------------------------------------------

# Implementação do Apache Ant

Alternativa Implementação:
- Criação de um ficheiro copia (alternativa)
-  Alterar o build.gradle para build.xml:
```<project name="PayrollApplication" default="run" basedir=".">
    
    <!-- Propriedades -->
    <property name="src.dir" value="src/main/java"/>
    <property name="build.dir" value="build"/>
    <property name="lib.dir" value="lib"/>
    <property name="main.class" value="payroll.PayrollApplication"/>
    
    <!-- Diretórios -->
    <target name="init">
        <mkdir dir="${build.dir}"/>
    </target>
    
    <!-- Compilar o código Java -->
    <target name="compile" depends="init">
        <javac srcdir="${src.dir}" destdir="${build.dir}/classes" includeantruntime="false">
            <classpath>
                <!-- Dependências -->
                <fileset dir="${lib.dir}">
                    <include name="**/*.jar"/>
                </fileset>
            </classpath>
        </javac>
    </target>

    <!-- Executar a aplicação -->
    <target name="run" depends="compile">
        <java classname="${main.class}" fork="true">
            <classpath>
                <pathelement path="${build.dir}/classes"/>
                <fileset dir="${lib.dir}">
                    <include name="**/*.jar"/>
                </fileset>
            </classpath>
        </java>
    </target>

    <!-- Dependências (Spring Boot e outras) -->
    <target name="fetch-dependencies">
        <!-- Baixar as dependências manualmente e colocar na pasta lib -->
        <echo message="Baixe as dependências do Spring Boot, JPA, HATEOAS e H2 para a pasta lib."/>
    </target>

    <!-- Testes com JUnit -->
    <target name="test" depends="compile">
        <junit printsummary="yes">
            <classpath>
                <pathelement path="${build.dir}/classes"/>
                <fileset dir="${lib.dir}">
                    <include name="**/*.jar"/>
                </fileset>
            </classpath>
            <batchtest>
                <fileset dir="${src.dir}">
                    <include name="**/*Test.java"/>
                </fileset>
            </batchtest>
        </junit>
    </target>

    <!-- Tarefa de backup -->
    <target name="backupSources">
        <copy todir="backup">
            <fileset dir="src"/>
        </copy>
    </target>

    <!-- Tarefa para criar arquivo zip do JavaDoc -->
    <target name="zipJavaDoc" depends="javadoc">
        <mkdir dir="${build.dir}/archives"/>
        <zip destfile="${build.dir}/archives/javadoc.zip" basedir="${build.dir}/docs/javadoc"/>
    </target>

    <!-- Limpeza do projeto -->
    <target name="clean">
        <delete dir="${build.dir}"/>
    </target>
</project>
```
- Instalar ant: 
```sudo apt install ant```
- Instalar o maven e baixar as depencias apartir dele: 
```sudo apt install maven```
```<project xmlns="http://maven.apache.org/POM/4.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>payroll</artifactId>
    <version>1.0-SNAPSHOT</version>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <version>3.0.0</version>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
            <version>3.0.0</version>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-hateoas</artifactId>
            <version>3.0.0</version>
        </dependency>

        <dependency>
            <groupId>com.h2database</groupId>
            <artifactId>h2</artifactId>
            <version>2.1.214</version>
            <scope>runtime</scope>
        </dependency>

        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-api</artifactId>
            <version>5.9.1</version>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-engine</artifactId>
            <version>5.9.1</version>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>com.google.guava</groupId>
            <artifactId>guava</artifactId>
            <version>31.1-jre</version>
        </dependency>
    </dependencies>
</project>
```
Apaga se o pom.xml
E corre-se o comando:
```sudo ant run```

O código apresenta a migração de um projeto Java para o **Apache Ant**, substituindo o **Gradle** como ferramenta de build. O **build.xml** define diversas tarefas automatizadas, como a compilação, execução e testes do projeto. 

Inicialmente, são configuradas propriedades para definir os diretórios de código-fonte, build, bibliotecas e a classe principal. A tarefa `init` cria o diretório de build, seguida pela tarefa `compile`, que compila o código Java, utilizando dependências externas armazenadas na pasta `lib`. A tarefa `run` executa a aplicação, utilizando o código compilado e as bibliotecas necessárias.

Além disso, há uma tarefa `fetch-dependencies`, que orienta o desenvolvedor a baixar manualmente as dependências (Spring Boot, JPA, HATEOAS, H2) e colocá-las no diretório `lib`. A tarefa `test` é responsável por executar os testes com JUnit. Outras tarefas adicionais incluem a criação de backups (`backupSources`), geração de JavaDocs (`zipJavaDoc`) e limpeza do projeto (`clean`).

O Maven é usado temporariamente para baixar as dependências necessárias através do `pom.xml`, sendo que, após o download, os arquivos `.jar` são colocados na pasta `lib` para uso pelo Ant. Depois, o comando `sudo ant run` é utilizado para compilar e executar o projeto.

--------------------------------
# Pontos negativos do Apache Ant comparado ao Gradle

Alguns dos pontos negativos do Apache Ant comparado ao Gradle são os seguintes:


## Falta de gestão automática de dependências:
-  Ant não oferece suporte nativo para a gestão automática de dependências. No Ant, é necessário baixar manualmente as bibliotecas e adicioná-las ao classpath, enquanto o Gradle utiliza o Maven Central ou outros repositórios para baixar e gerenciar automaticamente as dependências.

## Sintaxe mais complexa e verbosa:
- Os scripts do Ant geralmente são mais longos e detalhados, exigindo a configuração manual de cada tarefa, como compilação e execução. Em contraste, o Gradle usa uma DSL (Domain Specific Language) baseada em Groovy ou Kotlin, que torna o script mais conciso e legível.

## Falta de incrementalidade:
- Gradle tem suporte nativo para builds incrementais, o que significa que ele compila apenas o que foi alterado, resultando em builds mais rápidos. Ant, por padrão, recompila todo o projeto sempre que é executado, o que pode aumentar o tempo de compilação.

## Menos suporte para ecossistemas modernos: 
- Gradle é amplamente utilizado em projetos modernos, especialmente no desenvolvimento de aplicativos Android, e tem suporte integrado para frameworks e ferramentas populares. O Ant é considerado mais antigo e com menos suporte para frameworks novos.

## Integração e extensibilidade limitadas: 
- Enquanto Gradle tem plugins poderosos e integrados com ferramentas populares (como Docker, Jenkins, e IDEs), o Ant não possui a mesma extensibilidade de forma natural, exigindo configurações adicionais para muitas integrações.

## Menor desempenho em grandes projetos:
- Em projetos grandes e complexos, o Gradle é mais eficiente e escalável, otimizando as tarefas de build e oferecendo suporte a paralelismo, o que não é tão bem implementado no Ant.

---------
# Conclusão

O **Apache Ant**, embora ainda útil em projetos mais simples ou legados, apresenta limitações claras em comparação com ferramentas mais modernas como o **Gradle**. O Ant exige scripts verbosos e configurações manuais, especialmente na gestão de dependências, o que aumenta a complexidade e a manutenção do projeto. Ele também carece de funcionalidades mais avançadas, como builds incrementais e automação completa, resultando em processos de compilação mais lentos e menos otimizados.

Por outro lado, o **Gradle** oferece uma abordagem moderna, com uma sintaxe mais concisa e amigável, além de uma gestão automática de dependências, que facilita o trabalho do desenvolvedor. Suas funcionalidades de build incremental e suporte a paralelismo otimizam o desempenho em projetos grandes. Além disso, o Gradle tem uma excelente integração com ferramentas e frameworks populares, tornando-se a escolha preferida em projetos complexos e modernos, proporcionando maior eficiência e escalabilidade em comparação ao Ant.













