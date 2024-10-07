# CA1 - GIT

O controlo de versão é uma prática essencial no desenvolvimento de software, permitindo acompanhar e gerir alterações no
código-fonte de forma eficiente e colaborativa. No contexto desta atividade, o Git foi escolhido como a ferramenta
principal para gerir o repositório e as alterações associadas ao desenvolvimento de uma aplicação REST com Spring.

Este relatório descreve a implementação do CA1, onde foram exploradas várias funcionalidades do Git, incluindo a criação
de repositórios, commits, branches, merges e tags. Além disso, foram aplicadas práticas de versionamento sem branches na
primeira fase e com branches na segunda, a fim de assegurar uma gestão eficaz do código e das alterações propostas.

Por fim, o relatório também apresenta uma análise comparativa de soluções alternativas de controlo de versão, abordando
as suas principais características e como poderiam ser aplicadas para atingir objetivos semelhantes. Esta análise
permite um entendimento mais amplo das ferramentas de controlo de versão disponíveis, considerando cenários em que o Git
pode não ser a solução ideal.



## Parte 1

### Configuração Inicial

Primeiramente, o git foi instalado na máquina de cada estudante e efetuou-se a configuração através dos seguintes
comandos:

    $ git config --global user.name = "<Nome Apelido>"
    $ git config --global user.email = "<mecanográfico@isep.ipp.pt>"

Estes comandos configuram o user local com o nome e email corretos.


Foi ainda executado o seguinte comando, de forma a se alterar o editor de texto para o git para o 'nano'.

    $ git config --global core.editor nano




Seguidamente, criou-se um repositório no github disponível [aqui](https://github.com/isep-antoniodanielbf/cogsi2425-1190402-1200928-1222598).

Após a criação do repositório efetuou-se um clone do repositório na máquina de cada elemento do grupo:

    $ git clone https://github.com/isep-antoniodanielbf/cogsi2425-1190402-1200928-1222598

Para este trabalho optou-se pela utilização do Intellij como IDE principal. Foram efetuadas alterações no código de
forma a que se criasse um novo field.

### Primeira Parte da Configuração

Para inicializar este projeto, focou-se na branch main. Foi pedido para copiar o código clonado e alterado em CA0 para
uma nova pasta criada no repositório.

Para tal, no Command Prompt, primeiramente colocou-se na path onde o nosso _working directory_ se encontra: 
      
    C:\Users\<username>\Documents\GitHub\cogsi2425-1190402-1200928-1222598

Depois executou-se o seguinte comando a fim de listar todas as branches existentes atualmente (apenas branch Main).

    $ git branch

Dentro do path, irá-se criar a pasta com nome CA1 como é pedido no enunciado.

    $ mkdir CA1

Depois da pasta criada, é necessário colocar o código _Building REST services with Spring app_ dentro da CA1/part1.
Este comando irá permitir que a nova informação na pasta seja adicionada e guardada na _Staging Area_.

    $ git add *

Depois guardamos as novas alterações no repositório do grupo com adição de mensagem no _commit_.

    $ git commit -m "Added Spring app to CA1 folder"

Era pedido também para colocar uma _tag_ para identificar a versão da nossa aplicação.

    $ git tag 1.1.0

Depois deu-se o push total para o repositório tanto do _local main_ para o _main branch_ como também a _tag_ para esse
_branch_.

    $ git push origin main
    $ git push origin 1.1.0

Foi necessário efetuar autenticação no browser para ser possível a ação.

Ao aceder ao repositório online, é possível confirmar a
tag - [aqui](https://github.com/isep-antoniodanielbf/cogsi2425-1190402-1200928-1222598/tags).

### Alterações no código para adição do campo

Na classe "Employee", foram adicionados os seguintes componentes:

- A variável jobYears:

        private int jobYears;

Os gets e sets para a nova variável:

      public int getJobYears() {
          return this.jobYears;
      }

      public void setJobYears(int jobYears) { // Changed from setJobYears
          if (jobYears < 0) {
              throw new IllegalArgumentException("Years of experience cannot be negative.");
          }
          this.jobYears = jobYears;
      }

- Alteração no construtor da classe:

      Employee(String firstName, String lastName, String role, int jobYears) {

        if (firstName == null || firstName.isEmpty()) {
            throw new IllegalArgumentException("Employee firstName cannot be null or empty.");
        }
        if (lastName == null || lastName.isEmpty()) {
            throw new IllegalArgumentException("Employee lastName cannot be null or empty.");
        }
        if (role == null || role.isEmpty()) {
            throw new IllegalArgumentException("Employee role cannot be null or empty.");
        }
        if (jobYears < 0) {
            throw new IllegalArgumentException("Years of experience cannot be negative.");
        }

        this.firstName = firstName;
        this.lastName = lastName;
        this.role = role;
        this.jobYears = jobYears;
      }

    - Alteração dos métodos **equals(Object o)**, **hasCode()** e **toString()** para considerarem a variável jobYears

          @Override
          public boolean equals(Object o) {
    
            if (this == o)
              return true;
            if (!(o instanceof Employee))
                return false;
            Employee employee = (Employee) o;
            return Objects.equals(this.id, employee.id) && Objects.equals(this.firstName, employee.firstName)
                            && Objects.equals(this.lastName, employee.lastName) && Objects.equals(this.role, employee.role) && Objects.equals(this.jobYears, employee.jobYears);
          }
    
          @Override
          public int hashCode() {
            return Objects.hash(this.id, this.firstName, this.lastName, this.role, this.jobYears);
          }
    
          @Override
          public String toString() {
            return "Employee{" + "id=" + this.id + ", firstName='" + this.firstName + '\'' + ", lastName='" + this.lastName
            + '\'' + ", role='" + this.role + '\'' + ", jobYears='" + this.jobYears + '\'' + +'}';
              }

Na classe "EmployeeController", foram efetuadas as seguintes alterações (adição do fiels jobYears  no método):

- Alteração do método **replaceEmployee(@RequestBody Employee newEmployee, @PathVariable Long id)**

        	@PutMapping("/employees/{id}")
            ResponseEntity<?> replaceEmployee(@RequestBody Employee newEmployee, @PathVariable Long id) {

                    Employee updatedEmployee = repository.findById(id) //
                    .map(employee -> {
                        employee.setName(newEmployee.getName());
                        employee.setRole(newEmployee.getRole());
                        employee.setJobYears(newEmployee.getJobYears()); // linha adicionada
                        return repository.save(employee);
                    }) //
                    .orElseGet(() -> {
                        return repository.save(newEmployee);
                    });

  	            EntityModel<Employee> entityModel = assembler.toModel(updatedEmployee);

                return ResponseEntity.created(entityModel.getRequiredLink(IanaLinkRelations.SELF).toUri()).body(entityModel);
              }

Na classe "LoadDatabase", foram efetuadas as seguintes alterações:

- No método , foram alterados os dados para conterem o novo field jobYears

        employeeRepository.save(new Employee("Bilbo", "Baggins", "burglar",30));
  		employeeRepository.save(new Employee("Frodo", "Baggins", "thief",2));

Foram adicionadas validações para garantir que os valores não são nulos nem vazios e para que a idade seja superior a 0.

- Alterações nos métodos SET

         public void setFirstName(String firstName) {
            if (firstName == null || firstName.isEmpty()) {
                throw new IllegalArgumentException("Employe firstName cannot be null or empty.");
            }
            this.firstName = firstName;
        }

         public void setLastName(String lastName) {
              if (lastName == null || lastName.isEmpty()) {
              throw new IllegalArgumentException("Employe lastName cannot be null or empty.");
              }
              this.lastName = lastName;
         }

        public void setRole(String role) {
            if (role == null || role.isEmpty()) {
                throw new IllegalArgumentException("Employee role cannot be null or empty.");
            }
            this.role = role;
        }

        public void setJobYears(int jobYears) { // Changed from setJobYears
            if (jobYears < 0) {
                throw new IllegalArgumentException("Years of experience cannot be negative.");
            }
            this.jobYears = jobYears;
        }

Foram adicionadas validações para não permitir campos nulos, vazios e quantidades de anos de experiência menores que 0.

### Testes unitários

Foram criados os seguintes testes unitários:

    @Test
    void testValidEmployeeCreation() {
        Employee employee = new Employee("John", "Doe", "Engineer", 5);
        assertEquals("John", employee.getFirstName());
        assertEquals("Doe", employee.getLastName());
        assertEquals("Engineer", employee.getRole());
        assertEquals(5, employee.getJobYears());
    }

Descrição: Verifica se um objeto Employee pode ser criado com sucesso com atributos válidos (nome, sobrenome, cargo e
anos de experiência). Garante que os métodos "getter" retornam os valores esperados.

    @Test
    void testNullFirstName() {
        assertThrows(IllegalArgumentException.class, () -> new Employee(null, "Doe", "Engineer", 5));
    }

Descrição: Verifica se a tentativa de criar um Employee com um nome null resulta em uma IllegalArgumentException.

    @Test
    void testEmptyFirstName() {
        assertThrows(IllegalArgumentException.class, () -> new Employee("", "Doe", "Engineer", 5));
    }

Descrição: Testa se fornecer uma string vazia ("") como nome durante a criação do Employee aciona uma
IllegalArgumentException.

    @Test
    void testNullLastName() {
        assertThrows(IllegalArgumentException.class, () -> new Employee("John", null, "Engineer", 5));
    }

Descrição: Semelhante ao testNullFirstName(), mas foca em validar que um sobrenome null não é permitido.

    @Test
    void testEmptyLastName() {
        assertThrows(IllegalArgumentException.class, () -> new Employee("John", "", "Engineer", 5));
    }

Descrição: Análogo ao testEmptyFirstName(), este teste garante que um sobrenome vazio leva a uma
IllegalArgumentException.

    @Test
    void testNullRole() {
        assertThrows(IllegalArgumentException.class, () -> new Employee("John", "Doe", null, 5));
    }

Descrição: Confirma que passar um valor null para o atributo role durante a construção do Employee lança uma
IllegalArgumentException.

    @Test
    void testEmptyRole() {
        assertThrows(IllegalArgumentException.class, () -> new Employee("John", "Doe", "", 5));
    }

Descrição: Verifica se uma string de cargo vazia aciona uma IllegalArgumentException.

    @Test
    void testNegativeJobYears() {
        assertThrows(IllegalArgumentException.class, () -> new Employee("John", "Doe", "Engineer", -1));
    }

Descrição: Valida se fornecer um valor negativo para jobYears resulta em uma IllegalArgumentException, garantindo que o
número de anos de experiência não pode ser negativo.

No final de cada etapa (criação do novo field, validação dos campos, criação de testes unitários), foram criados commits
no repositório da seguinte forma:

    $ git add *
    $ git commit -m "<Message>"
    $ git push

Após a execução destes comandos, dado que a branch não foi alterada, as alterações foram carregadas para o github para a
branch principal.

Na mensagem foi inserido o <#ISSUE ID> para permitir que o commit seja associado à respetiva issue
no  [projeto GITHUB](https://github.com/users/isep-antoniodanielbf/projects/1).

### Testes da Funcionalidade Get e Post com Postman

De forma a facilitar a partilha dos testes Postman com o grupo, criou-se um Workspace:

Postman: [Team Workspace](https://cogsi2425-04.postman.co/workspace/COGSI2425-04-Workspace~55bbdaf7-0e6e-49e0-ae99-68c6b991c1bd/collection/38664210-d336b2b7-38cc-4954-a2e0-599a60eecb5d?action=share&creator=38664210)

#### GET ALL

O método GET é um dos pilares do protocolo HTTP (Hypertext Transfer Protocol), sendo amplamente utilizado para
requisitar dados de um servidor.

De seguida, apresentamos um exemplo prático da utilização de uma API, ilustrando tanto o código do pedido como a
estrutura de uma resposta bem-sucedida,

**Endpoint**: http://localhost:8080/employees

    {
    "_embedded": {
    "employeeList": [
    {
    "id": 1,
    "firstName": "Bilbo",
    "lastName": "Baggins",
    "role": "burglar",
    "jobYears": 30,
    "name": "Bilbo Baggins",
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees/1"
    },
    "employees": {
    "href": "http://localhost:8080/employees"
    }
    }
    },
    {
    "id": 2,
    "firstName": "Frodo",
    "lastName": "Baggins",
    "role": "thief",
    "jobYears": 2,
    "name": "Frodo Baggins",
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees/2"
    },
    "employees": {
    "href": "http://localhost:8080/employees"
    }
    }
    }
    ]
    },
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees"
    }
    }
    }

#### GET BY ID: 2

Abaixo está um exemplo de teste realizado com o método GET, onde se faz uma pesquisa pelo _Employee_ com o _id_ 2.

**Endpoint**: http://localhost:8080/employees/2

    {
    "id": 2,
    "firstName": "Frodo",
    "lastName": "Baggins",
    "role": "thief",
    "jobYears": 2,
    "name": "Frodo Baggins",
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees/2"
    },
    "employees": {
    "href": "http://localhost:8080/employees"
    }
    }
    }

#### POST

Enquanto o método GET é usado para obter dados do servidor, o método POST tem a função de enviar dados para o servidor,
permitindo a criação de recursos, o envio de formulários ou a atualização de informações no servidor.

Vejamos um exemplo prático de criação de um _Employee_:

**Endpoint**: http://localhost:8080/employees

**Corpo do Pedido**:

    {
    "firstName": "Jorge",
    "lastName":"Almeida",
    "role": "CTO",
    "jobYears": "2"
    }

Aqui observamos a resposta que foi enviada com o novo Employee:

    {
    "id": 3,
    "firstName": "Jorge",
    "lastName": "Almeida",
    "role": "CTO",
    "jobYears": 2,
    "name": "Jorge Almeida",
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees/3"
    },
    "employees": {
    "href": "http://localhost:8080/employees"
    }
    }
    }

#### GET ALL com Post Validação de utilidade

De seguida, fez-se um novo Get All para se obter a lista completa dos _Employees_, de forma a que se consiga validar que
o POST teve sucesso:

**Employees**: http://localhost:8080/employees

    {
    "_embedded": {
    "employeeList": [
    {
    "id": 1,
    "firstName": "Bilbo",
    "lastName": "Baggins",
    "role": "burglar",
    "jobYears": 30,
    "name": "Bilbo Baggins",
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees/1"
    },
    "employees": {
    "href": "http://localhost:8080/employees"
    }
    }
    },
    {
    "id": 2,
    "firstName": "Frodo",
    "lastName": "Baggins",
    "role": "thief",
    "jobYears": 2,
    "name": "Frodo Baggins",
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees/2"
    },
    "employees": {
    "href": "http://localhost:8080/employees"
    }
    }
    },
    {
    "id": 3,
    "firstName": "Jorge",
    "lastName": "Almeida",
    "role": "CTO",
    "jobYears": 2,
    "name": "Jorge Almeida",
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees/3"
    },
    "employees": {
    "href": "http://localhost:8080/employees"
    }
    }
    }
    ]
    },
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees"
    }
    }
    }

### Comando GIT Log

O comando `git log` é uma ferramenta fundamental no Git para visualizar o histórico de commits num repositório. Ele
fornece uma visão detalhada das alterações realizadas ao longo do tempo, permitindo que se acompanhe o desenvolvimento
do projeto e se entenda as contribuições de cada membro da equipa.

**Informações exibidas pelo `git log`**:

* **Hash do commit**: Um identificador único para cada commit, permitindo referenciá-lo de forma precisa.
* **Autor**: O nome da pessoa que realizou o commit.
* **Data**: A data e hora em que o commit foi criado.
* **Mensagem do commit**: Uma breve descrição das alterações realizadas no commit.
* **Outras informações**: Dependendo das opções utilizadas, o `git log` pode exibir também detalhes como os arquivos
  modificados, as linhas de código adicionadas ou removidas e as ramificações (branches) afetadas.

      $ git log
    
      Changes to be committed:
      (use "git restore --staged <file>..." to unstage)
      new file:   .idea/.gitignore
      new file:   .idea/vcs.xml
      modified:   CA1/Readme.md
    
      jorgealmeida@MacBook-Pro-de-Jorge-2 cogsi2425-1190402-1200928-1222598 % git log
      commit e694e4e21bb98d9b22c18b9c0bcc12b427f9ffb4 (HEAD -> main, origin/main, origin/HEAD)
      Author: António Daniel Barbosa Fernandes <1190402@isep.ipp.pt>
      Date:   Sat Sep 28 19:35:11 2024 +0100

        alteração do readme para a pasta CA1

Existem outras flags de combinações que acompanham o comando `git log`, que servem para sintetizar as
informações desejadas. De seguida, serão apresentados alguns exemplos:

Para exibir os três últimos ‘updates’ realizados pelos ‘user’.

    $ git log -n 3

Para exibir, resumidamente, as informações do commit (1 por linha):

    $ git log --oneline
    
    e694e4e (HEAD -> main, origin/main, origin/HEAD) alteração do readme para a pasta CA1
    8000dfa #3 #4 implementação das alterações no módeulo links
    efbefe4 fixing~
    a5a9757 fixing~
    aa0502c fix
    6be77bf Teste Commit Jorge Almeida
    fce0834 #1 divisão em 2 partes do CA1
    f084b13 Teste Commit Jorge Almeida
    f0ac514 Teste Commit Jorge Almeida
    3788b7a Teste Commit Jorge Almeida
    297136e #7 remoção de texto desnecessário no report
    82cd9ea #7 Added First Part - No branches
    154fba7 #4 #7 #9 Alteração do teste unitário para caso de sucesso, inserção de explicação sobre as alterações no código e testes unitários no report
    4c87dc2 #1 Remoção de pastas desnecessárias
    da99c4d Teste GIT
    dfa79ae #7 Adição do readme.md com explicação base dos comandos git
    50d2431 Solving an issue on Employee class
    53a195f Adding some unity tests for the Employee class
    13634a1 Adding the jobYears field to the Employee class
    9582a1b (tag: 1.1.0) Added Spring app to CA1 folder
    651cc3f Update .gitignore

Para verificar as alterações realizadas pelo autor, além de exibir a quantidade de linhas adicionadas,
removidas e quais ficheiros foram alterados em cada commit.

    $ git log --stat

Exibirá as alterações realizadas pelo autor, isso ajudará muito na procura exata de determinado Autor:

    $ git log --author="<Nome do Autor>"

Exibirá commits feitos num período específico:

    $ git log --since="ano-mes-dia" --until="ano-mes-dia"

Irá procurar palavras-chave de commits realizados de todos os autores.

    $ git log --grep="<padrão>"

Este comando é de suma importância, irá exibir o histórico visual das branches e commits. Nele estará
contido um gráfico das estruturas das branches, onde mostrará os commits conectados.

    $ git log --oneline --graph --all

Output:

    * 3d4f0f3 (HEAD -> main, origin/main, origin/HEAD) ## Implementação das alternativas
      * 6c37916 ## Análise das alternativas
      * 938f835 #8 Adicionado ao relatório a tarefa do fixing-invalid-email
      * 5e159bd ## update
      * 93c6428 ## remoção
      *   84b610f Merge remote-tracking branch 'origin/main'
          |\
          | * 0ba9d34 Create security-scan.yml
          | * 35eb646 Create vulnerabillidades.yml
          | * b4f5e4d Create vulnerabilidades.yml
      * | 0d8387d ## Análise das alternativas
        |/
      * 6b8a525 Create delete-artefatos.yml
      * 1a8e50f exclução pipeline
      * 3cac2c5 Code Vulnerabilidades correção
      * d3d6f5e Code Vulnerabilidades
      * a196d72 Update main-pipeline.yml


De seguida testou-se a opção "--pretty=format" do comando git log:

    $ git log --pretty=format:"%h - %an, %ar : %s"

Neste exemplo:

* %h mostra o hash abreviado do commit.
* %an mostra o nome do autor.
* %ar mostra o tempo em que o commit foi feito em um formato relativo (por exemplo, "2 weeks ago").
* %s exibe a mensagem do commit.

Exemplo de Output:

    3d4f0f3 - =, 9 hours ago : ## Implementação das alternativas
    6c37916 - =, 9 hours ago : ## Análise das alternativas
    938f835 - =, 2 days ago : #8 Adicionado ao relatório a tarefa do fixing-invalid-email
    5e159bd - =, 2 days ago : ## update
    93c6428 - =, 2 days ago : ## remoção
    84b610f - =, 2 days ago : Merge remote-tracking branch 'origin/main'
    0d8387d - =, 2 days ago : ## Análise das alternativas
    0ba9d34 - Jorge Almeida, 2 days ago : Create security-scan.yml
    35eb646 - Jorge Almeida, 2 days ago : Create vulnerabillidades.yml
    b4f5e4d - Jorge Almeida, 2 days ago : Create vulnerabilidades.yml
    6b8a525 - Jorge Almeida, 2 days ago : Create delete-artefatos.yml
    1a8e50f - =, 2 days ago : exclução pipeline
    3cac2c5 - =, 2 days ago : Code Vulnerabilidades correção
    d3d6f5e - =, 2 days ago : Code Vulnerabilidades
    a196d72 - António Daniel Barbosa Fernandes, 2 days ago : Update main-pipeline.yml
    f146a00 - =, 2 days ago : #### Pipeline para remoção de artefatos com mais de 20 dias.
    08b2e70 - António Daniel Barbosa Fernandes, 2 days ago : Update pom.xml
    81bd85c - António Daniel Barbosa Fernandes, 2 days ago : Update pom.xml
    723d6f3 - António Daniel Barbosa Fernandes, 2 days ago : Update pom.xml
    a7ad681 - António Daniel Barbosa Fernandes, 2 days ago : Update main-pipeline.yml
    2a253c5 - António Daniel Barbosa Fernandes, 3 days ago : Update main-pipeline.yml
    f340a0c - António Daniel Barbosa Fernandes, 3 days ago : Update main-pipeline.yml - build + test
    7f1f1af - António Daniel Barbosa Fernandes, 3 days ago : Update main-pipeline.yml

## Aplicar TAG nos Commits e Push.

Iremos agora utilizar um recurso disponível no GIT, que servirá para controle,
das versões do nosso projeto, para acompanhar todas as atualizações feitas pelos autores.

Este comando irá mostrar os resultados da versão atual do projeto:

    $ git tag
    1.1.0

Uma observação muito importante, que o GIT suporta duas TAG, sendo elas :  
lightweight and annotated ou seja as tag leves são como ponteiros específicos do commit,
as anotadas são como objetos guardados na base de dados do GIT onde são:
▪ Eles são verificados
▪ Contêm o nome do marcador, e-mail e data
▪ Têm uma mensagem de marcação

Exemplo de como Criar uma TAG lightweight:

    $ git tag v1.2 -po

Exemplo de como criar uma TAG annotated:

    $ git tag -a v1.2 -m "minha version 1.2"   

Utilizamos as ‘flags’ -a e -m para introduzir algumas informações importantes,
tais eles são:

    -a (atribuí a identificação de uma tag anotada)
    -m (atribuí uma mensagem ao criar uma tag)

O comando abaixo irá especificar informações da TAG desejada:

    $ git show v1.2

O comando abaixo irá identificar uma TAG com o valor do hash após o commit realizado:

    $ git tag -a v1.2 <COMMIT_HASH>

Isto é uma forma de organizarmos melhor, para qual versão foi dado aquele commit.

Exemplo de como enviar uma TAG através do Push. Haja vista que o PUSH não transfere as TAG
para um servidor remoto, neste caso iremos demonstra uma forma de como enviá-los.

    $ git push origin v1.2

Exemplo de enviar todas as TAGs:

    $ git push origin --tags

Agora, quando outra pessoa clonar ou extrair do seu repositório,
eles também obterão todas as suas tags.

Comando para deletar uma TAG:

    $ git tag -d 'v1.2-lw'
    Deleted tag 'v1.2-lw' (was e7d5add)

Para deletar uma TAG, é necessário passar o parâmetro — d mais o nome da TAG desejada.
O git irá responder com a confirmação do nome mais as hash que foi atribuída a mesma.

Para deletar uma TAG remota, utilizaremos o seguinte comando:

    $ git push origin --delete v1.0

## Demonstração de como utilizar o GIT Revert:

    CA1/part1/ficheiroparareverter.txt

com o texto "teste"

Para reverter, foi efetuado o seguinte comando:

* Reverter para o commit imediatamente anterior:

    
    $ git revert HEAD - anterior mantendo na história

* Reverter para um commit específico:

 
     $ git revert 3b89984374f1bc0d0daa1dbc6229add4ca15af4b

Para reverter para o commit onde foi criada a tag v1.2

Após executar o git revert, você é necessário seguir os passos padrão do fluxo de trabalho do Git (add, commit, push).

* git add: Adicione o novo commit de reversão à área de staging. Isso prepara o commit para ser incluído no histórico do
  Git.

* git commit: Confirma o commit de reversão, fornecendo uma mensagem descritiva que explica o motivo da reversão.

* git push: Envia o novo commit de reversão para o repositório remoto, para que outros colaboradores também tenham
  acesso à reversão.

Ao contrário do comando git reset, o comando preserva as alterações na história, estando a mesma sempre disponível para
todos.


Para concluir a parte 1, criou-se uma nova tag com os comandos já referidos acima, e fez-se pull da mesma para o repositório.


    $ git tag ca1-part1

    $ git push origin --tags


## Parte 2


## Criação Branch Para release


### Criação do email field

#### Criação da branch email-field

Para começar, foi criada a branch email-field através do seguinte comando:

    $ git checkout -b email-field

A partir daqui, os commits feitos localmente passam a apontar para essa branch até que se volte a alterar par a
principal.

#### Alterações no código da solução

* Nova variável

      private String email;

Foi criada a nova variável do tipo String chamada email.

* Alterações ao nível do construtor, gets e sets:


    Employee(String firstName, String lastName, String role, int jobYears, String email) {

      if (firstName == null || firstName.isEmpty()) {
      throw new IllegalArgumentException("Employee firstName cannot be null or empty.");
      }
      if (lastName == null || lastName.isEmpty()) {
      throw new IllegalArgumentException("Employee lastName cannot be null or empty.");
      }
      if (role == null || role.isEmpty()) {
      throw new IllegalArgumentException("Employee role cannot be null or empty.");
      }
      if (jobYears < 0) {
      throw new IllegalArgumentException("Years of experience cannot be negative.");
      }
      
      
      if (email == null || email.isEmpty()) {
      throw new IllegalArgumentException("Employee email cannot be null or empty.");
      }
      
      
      this.firstName = firstName;
      this.lastName = lastName;
      this.role = role;
      this.jobYears = jobYears;
      this.email = email;
    }

Adicionou-se o campo e a validação do mesmo para não permitir valores nulos ou vazios.

O mesmo no método set:

    public String getEmail() {
    return this.email;
    }
    
    
    public void setEmail(String email) {
    if (email == null || email.isEmpty()) {
    throw new IllegalArgumentException("Employee email cannot be null or empty.");
    }
    this.email = email;
    }

* Alterações ao nível do equals(), hash() e toString()


    @Override
    public boolean equals(Object o) {
    
    
    if (this == o)
    return true;
    if (!(o instanceof Employee))
    return false;
    Employee employee = (Employee) o;
    return Objects.equals(this.id, employee.id)
    && Objects.equals(this.firstName, employee.firstName)
    && Objects.equals(this.lastName, employee.lastName)
    && Objects.equals(this.role, employee.role)
    && Objects.equals(this.jobYears, employee.jobYears)
    && Objects.equals(this.email, employee.email);
    }
    
    
    @Override
    public int hashCode() {
    return Objects.hash(this.id, this.firstName, this.lastName, this.role, this.jobYears
    , this.email);
    }
    
    
    @Override
    public String toString() {
    return "Employee{" + "id=" + this.id + ", firstName='" + this.firstName + '\'' +
    ", lastName='" + this.lastName + '\'' + ", role='" + this.role + '\'' +
    ", jobYears='" + this.jobYears + '\'' +
    ", email='" + this.email + '\'' + +'}';
    }

Foi adicionado o novo campo.

* Alterações no controller:



    @PutMapping("/employees/{id}")
    ResponseEntity<?> replaceEmployee(@RequestBody Employee newEmployee, @PathVariable Long id) {

        Employee updatedEmployee = repository.findById(id) //
                .map(employee -> {
                    employee.setName(newEmployee.getName());
                    employee.setRole(newEmployee.getRole());
                    employee.setJobYears(newEmployee.getJobYears());
                    employee.setEmail(newEmployee.getEmail());
                    return repository.save(employee);
                }) //
                .orElseGet(() -> {
                    return repository.save(newEmployee);
                });

        EntityModel<Employee> entityModel = assembler.toModel(updatedEmployee);

        return ResponseEntity.created(entityModel.getRequiredLink(IanaLinkRelations.SELF).toUri()).body(entityModel);
  }

* Novos testes unitários:


    @Test
    void testValidEmployeeCreation()
    
    
    {
    Employee employee = new Employee("John", "Doe", "Engineer", 5,
    "john.doe@example.com");
    assertEquals("John", employee.getFirstName());
    assertEquals("Doe", employee.getLastName());
    assertEquals("Engineer", employee.getRole());
    assertEquals(5, employee.getJobYears());
    assertEquals("john.doe@example.com", employee.getEmail());
    }
    
    
    @Test
    void testNullFirstName() {
    assertThrows(IllegalArgumentException.class, () -> new Employee(null, "Doe",
    
    
               "Engineer", 5, "john.doe@example.com"));
    }
    
    
    @Test
    void testEmptyFirstName() {
    assertThrows(IllegalArgumentException.class, () -> new Employee("", "Doe",
    "Engineer", 5, "john.doe@example.com"));
    }
    
    
    @Test
    void testNullLastName() {
    assertThrows(IllegalArgumentException.class, () -> new Employee("John", null,
    "Engineer", 5, "john.doe@example.com"));
    }
    
    
    @Test
    void testEmptyLastName() {
    assertThrows(IllegalArgumentException.class, () -> new Employee("John", "",
    "Engineer", 5, "john.doe@example.com"));
    }
    
    
    @Test
    void testNullRole() {
    assertThrows(IllegalArgumentException.class, () -> new Employee("John", "Doe", null,
    5, "john.doe@example.com"));
    }
    
    
    @Test
    void testEmptyRole() {
    assertThrows(IllegalArgumentException.class, () -> new Employee("John", "Doe", "",
    5, "john.doe@example.com"));
    }
    
    
    @Test
    void testNegativeJobYears() {
    assertThrows(IllegalArgumentException.class, () -> new Employee("John", "Doe",
    "Engineer", -1, "john.doe@example.com"));
    }
    
    
    @Test
    void testValidEmail() {
    Employee employee = new Employee("John", "Doe", "Engineer", 5,
    "john.doe@example.com");
    assertEquals("john.doe@example.com", employee.getEmail());
    }
    
    
    @Test
    void testNullEmail() {
    assertThrows(IllegalArgumentException.class, () -> new Employee("John", "Doe",
    "Engineer", 5, null));
    }
    
    
    @Test
    void testEmptyEmail() {
    assertThrows(IllegalArgumentException.class, () -> new Employee("John", "Doe",
    "Engineer", 5, ""));
    }

O novo campo foi adicionado aos testes já existentes e foram criados dois novos para garantir que a aplicação não
permite valores nulos ou vazios.

* Bootstrap para a base de dados:


    employeeRepository.save(new Employee("Bilbo", "Baggins", "dev", 30,"dev1@company.com"));
    employeeRepository.save(new Employee("Frodo", "Baggins", "cto", 2,"cto1@company.com"));

#### Validação da solução através do postman

* GET ALL

**Endpoint**:http://localhost:8080/employees

**Resposta**:

    {
    "_embedded": {
    "employeeList": [
    {
    "id": 1,
    "firstName": "Bilbo",
    "lastName": "Baggins",
    "role": "dev",
    "jobYears": 30,
    "email": "dev1@company.com",
    "name": "Bilbo Baggins",
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees/1"
    },
    "employees": {
    "href": "http://localhost:8080/employees"
    }
    }
    },
    {
    "id": 2,
    "firstName": "Frodo",
    "lastName": "Baggins",
    "role": "cto",
    "jobYears": 2,
    "email": "cto1@company.com",
    "name": "Frodo Baggins",
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees/2"
    },
    "employees": {
    "href": "http://localhost:8080/employees"
    }
    }
    }
    ]
    },
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees"
    }
    }
    }

Conseguiu-se obter todos os Employees, já com o novo campo email.

* POST

**Endpoint**:http://localhost:8080/employees

**Corpo do request**:

    {
    "firstName": "Jorge",
    "lastName":"Almeida",
    "role": "CTO",
    "jobYears": "2",
    "email":"jorge.almeida@company.com"
    }

**Resposta**:

    {
    "id": 3,
    "firstName": "Jorge",
    "lastName": "Almeida",
    "role": "CTO",
    "jobYears": 2,
    "email": "jorge.almeida@company.com",
    "name": "Jorge Almeida",
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees/3"
    },
    "employees": {
    "href": "http://localhost:8080/employees"
    }
    }
    }

Conseguiu-se criar um novo Employee.

* GET BY ID

**Endpoint**: http://localhost:8080/employees/3

**Resposta**:

    {
    "id": 3,
    "firstName": "Jorge",
    "lastName": "Almeida",
    "role": "CTO",
    "jobYears": 2,
    "email": "jorge.almeida@company.com",
    "name": "Jorge Almeida",
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees/3"
    },
    "employees": {
    "href": "http://localhost:8080/employees"
    }
    }
    }

Conseguimos obter os dados do Employee criado.

* DELETE

**Endpoint**: http://localhost:8080/employees/3

Foi possível apagar o Employee, conforme o teste abaixo também mostra:

* GET para comprovar delete:

**Endpoint**: http://localhost:8080/employees/3

**Resposta**:

    {
    "_embedded": {
    "employeeList": [
    {
    "id": 1,
    "firstName": "Bilbo",
    "lastName": "Baggins",
    "role": "dev",
    "jobYears": 30,
    "email": "dev1@company.com",
    "name": "Bilbo Baggins",
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees/1"
    },
    "employees": {
    "href": "http://localhost:8080/employees"
    }
    }
    },
    {
    "id": 2,
    "firstName": "Frodo",
    "lastName": "Baggins",
    "role": "cto",
    "jobYears": 2,
    "email": "cto1@company.com",
    "name": "Frodo Baggins",
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees/2"
    },
    "employees": {
    "href": "http://localhost:8080/employees"
    }
    }
    }
    ]
    },
    "_links": {
    "self": {
    "href": "http://localhost:8080/employees"
    }
    }
    }

#### Merge do código da branch email-field para main

Executaram-se os seguintes comandos:

* Garantir que se está na branch main:


    $ git checkout main

* Fazer merge do conteúdo da email-field com a main:


    $ git merge origin/email-field

    $ git push origin main

#### Marcação com TAG da versão 1.3.0

    $ git tag v1.3.0

    $ git push origin --tags

O primeiro comando marca com a tag v1.3.0 e o segundo "sincroniza" as tags com o repositório remoto.


#### Criação de branch para corrigir erros

Foi criada a branch com nome fixing-invalid-email.

    $ git branch fixing-invalid-email

Vamos confirmar através do comando:

    $ git branch

O servidor deve aceitar apenas funcionários com um email válido. portanto, é necessário aceder e alterar o código na class Employee (e também nos testes unitários).


Para tal, foi importado e usado expressões regulares (Regex) Pattern e Matcher.

    import java.util.regex.Pattern;
    import java.util.regex.Matcher;

O Regex ajuda a definir e a utilizar padrões de texto.
O Pattern define a expressão regular, ou seja, o padrão que se pretende encontrar, neste caso, no email.

    private static final String EMAIL_REGEX = "^[\\w!#$%&'*+/=?`{|}~^.-]+@[\\w.-]+\\.[a-zA-Z]{2,7}$";

o ^ apenas identifica o início da string email e o $ o seu final.

Neste caso o padrão de email é o seguinte [\\w!#$%&'*+/=?`{|}~^.-]+ e [\\w.-]+\\.[a-zA-Z]{2,7}$ .

O \\w significa que o email, antes do @, pode conter letras (a-z), dígitos (0-9) e sublinhados (_).

O !#$%&'*+/=?`{|}~^.- significa estes caracteres especiais são permitidos na parte local do endereço de email.

O + significa sempre que se pode repetir os caracteres.

Depois do @, vem o domínio divido entre domínio de segundo nível e domínio de topo.

O \\w.- significa que o nome do domínio de segundo nível pode conter conter letras, números, underscores e hífens antes
do ponto.

Depois do ponto, o domínio de topo pode apenas ter 2 a 7 caracteres alfabéticos de comprometimento - [a-zA-Z]{2,7}.

O Matcher permite verificar se esse padrão aparece numa string e se existe correspondência.

* Alterações a nível do construtor e set:

  Foi removido o método email.isEmpty() e adicionado o !isValidEmail(email) de modo a verificar se o email introduzido é
  inválido (! é a negação do resultado).

      if (email == null || !isValidEmail(email)) {
      throw new IllegalArgumentException("ERROR - Invalid email.");
      }
  Feita a mesma alteração para o set:

      public void setEmail(String email) {
      if (email == null || !isValidEmail(email)) {
      throw new IllegalArgumentException("ERROR - Invalid email.");
      }
      this.email = email;
      }
* Adição de método isValidEmail()

  Este valida a string fornecida (email) segue o formato de email válido -> expressão regular (regex) mencionada acima.

      public static boolean isValidEmail(String email) {
      Pattern pattern = Pattern.compile(EMAIL_REGEX);
      Matcher matcher = pattern.matcher(email);
      return matcher.matches();
      }
  Irá comparar o email introduzido com o padrão e depois retorna true ou false dependendo se este é válido ou não.


* Alteração nos testes unitários:

  Foram realizados 3 formas de emails errados no teste. O primeiro não tem domínio de topo. O segundo tem apenas o
  domínio e o terceiro tem apenas uma palavra.
  Este teste prova a eficácia do código, dado provar não aceitar emails inválidos.


    @Test
    void testInvalidEmail() {
        assertThrows(IllegalArgumentException.class, () -> new Employee("John", "Doe",
                "Engineer", 5, "cogsi@isep"));
        assertThrows(IllegalArgumentException.class, () -> new Employee("John", "Doe",
                "Engineer", 5, "cogsi.com"));
        assertThrows(IllegalArgumentException.class, () -> new Employee("John", "Doe",
                "Engineer", 5, "cogsi"));
    }


#### Validação da solução através do Postman

* Post

Employee fail 1 -
**Endpoint**:http://localhost:8080/employees

**Corpo do request**:

    {
    "firstName": "Jorge",
    "lastName":"Almeida",
    "role": "CTO",
    "jobYears": "2",
    "email":"jorge.almeidacompany.com"
    }   

Testado email inválido - Sem @

**Resposta**:

    Could not send request
    Error: connect ECONNREFUSED 127.0.0.1:8080

Employee fail 2 -
**Endpoint**:http://localhost:8080/employees

**Corpo do request**:

    {
    "firstName": "Jorge",
    "lastName":"Almeida",
    "role": "CTO",
    "jobYears": "2",
    "email":"jorge.almeida@companycom"
    }

Testado email inválido - Sem .

**Resposta**:

    Could not send request
    Error: connect ECONNREFUSED 127.0.0.1:8080

* GET ALL

**Endpoint**:http://localhost:8080/employees

Deste modo, permite provar que ambos os exemplos anteriores não foram de facto criados (tentativa falhada de inserir emails inválidos). Cosequentemente, podemos dar esta tarefa de fixing-invalid-email e os testes associados como bem sucedidos e finalizados.


Depois realizou-se os seguintes comandos para adicionar o código à branch:

      $ git add *
      $ git commit -m "<mensagem>"
      $ git push --set-upstream origin fixing-invalid-email



#### Merge do código da branch fixing-invalid-email para main

Executaram-se os seguintes comandos:

* Garantir que se está na branch main:


    $ git checkout main

* Fazer merge do conteúdo da fixing-invalid-email com a main e por fim push para o repositório:
  (pode-se fazer git pull origin main antes de fazer o merge)


    $ git merge fixing-invalid-email
    $ git push origin main

#### Marcação com TAG da versão 1.3.1

    git tag
    git tag v1.3.1
    git push origin --tags

O primeiro comando possibilita listar as tags.

Os restantes marcam com a tag v1.3.1 e "sincronizam" a tag com o repositório remoto.

## Análise das alternativas

**_1. Mercurial (Hg)_**

É um sistema de controlo de versão distribuído de código aberto licenciado sob os termos da
GNU General Public License Versão 2. Desenvolvido principalmente em Python e em C, Mercurial é referenciado
várias vezes por (hg), por conta do elemento químico Mercúrio. Teve a sua primeira release em 2005,
data próxima ao do sistema de controlo de versão git. Em comparativos com outros controles de versão,
demonstra bom nível de feature e desempenho, sendo melhor em determinados aspectos.


Vantagens:

* Simples de usar;
* Melhor para operações com grandes repositórios.

Desvantagens:

* Menos popular;
* Menor suporte da comunidade e integração com outras ferramentas.

Pontos Fortes:

* Simplicidade;
* Desempenho com grandes repositórios.

Pontos Fracos:

* Menor suporte da comunidade;
* Menos integração.

Tipo do Software:

* Open source.

**_2. Subversion (SVN)_**

É usado para manter versões atuais e históricas de projetos.
O Subversion é um sistema de controlo de versão centralizado de código aberto .
Também é conhecido como um sistema de controlo de versão e revisão de software.

Vantagens:

* Histórico detalhado e suporte a grandes arquivos binários.
* Controlo centralizado.

Desvantagens:

* Operações mais lentas.
* Menos flexível para desenvolvimento distribuído.

Pontos Fortes:

* Controle centralizado.
* Detalhe de histórico, bom para grandes arquivos binários.

Pontos Fracos:

* Lentidão em algumas operações.
* Pouca flexibilidade para equipes distribuídas.

Tipo do Software:

* Open source

_**3. Perforce Helix Core**_

É uma plataforma de controlo e colaboração de conteúdo em uma versão
a nível corporativo que oferece tanto flexibilidade quanto controle sob
todos os aspetos dos crescentes sistemas complexos que os times de desenvolvimento
modernos têm construído.

Vantagens:

* Ótimo para grandes repositórios e equipas.
* Controle de permissões avançado.

Desvantagens:

* Custo elevado.
* Curva de aprendizado alta e configuração complexa.

Pontos Fortes:

* Controle granular.
* Suporta arquivos grandes, ideal para empresas.

Pontos Fracos:

* Curva de aprendizado íngreme.
* Custo elevado.

Tipo do Software:

* Proprietário (oferece uma versão gratuita limitada).

_**4. Bazaar**_

É um sistema de controlo de versão distribuído. Ele foi desenvolvido para ajudar equipas a gerir o desenvolvimento
de software, monitorizando alterações no código ao longo do tempo e facilitando a colaboração entre desenvolvedores.

Vantagens:

* Fluxo de trabalho flexível (centralizado e distribuído).
* Fácil de usar.

Desvantagens:

* Menor adoção.
* Desenvolvimento desacelerado e menor integração.

Pontos Fortes:

* Flexibilidade de fluxo.
* Fácil de usar.

Pontos Fracos:

* Menor popularidade.
* Desenvolvimento desacelerado.

Tipo do Software:

* Open source

**_5. Fossil_**

É um sistema de controlo de versão distribuído que se destaca por integrar várias
ferramentas de desenvolvimento num único pacote. Ele foi criado por Richard Hipp,
o mesmo desenvolvedor do banco de dados SQLite, para ser uma solução
simples e eficiente para projetos de ‘software’.

Vantagens:

* Leve.
* Sistema integrado de bug tracking e wiki.
* Fácil instalação.

Desvantagens:

* Menos popular.
* Menos recurso comparado a outros sistemas.

Pontos Fortes:

* Sistema leve. 
* Funcionalidades integradas (bug tracking e wiki).

Pontos Fracos:

* Menor adoção.
* Menos recursos.

Tipo do Software:

* Open source

**_6. Team Foundation Version Control (TFVC)_**

É um sistema de controlo de versão centralizado, parte do conjunto de ferramentas
oferecido pelo Microsoft Azure DevOps (antigo Team Foundation Server ou TFS).
É utilizado principalmente em ambientes corporativos para gerir o desenvolvimento
de código-fonte e facilitar a colaboração entre equipes. Embora seja menos popular
do que sistemas distribuídos como Git, o TFVC ainda é amplamente utilizado
em muitos projetos Microsoft e ambientes Windows.

Vantagens:

* Integração com Azure DevOps. 
* Bom para ambientes corporativos Microsoft.

Desvantagens:

* Centralizado.
* Falta de suporte para fluxo de trabalho distribuído.

Pontos Fortes:

* Integração com Azure DevOps.
* Bom suporte corporativo.

Pontos Fracos:

* Falta de suporte para desenvolvimento distribuído.
* Centralizado.

Tipo do Software:

* Open source

## Implementação das alternativas

Iremos agora demonstrar duas ferramentas de controlo de versão, como é a sua implementação.
Acima descrevemos quais as vantagens e desvantagens em termos essas ferramentas no nosso dia a dia.
Foi escolhido o controlo de versões o Fossil e Team Foundation Version Control.


## Instalação alternativa Fossil

Instalar o Fossil no seu ambiente, está disponível para Windows, macOS e Linux.

No Windows: Baixe o executável do site oficial Fossil Download e adicione ao PATH do sistema.

* No macOS: Utilize o brew para instalar:

      brew install fossil

* No Linux: Utilize o apt-get (Debian/Ubuntu) ou yum (RedHat/CentOS) para instalar:

      sudo apt-get install fossil

## Criar um Repositório Fossil

    fossil init meu_repositorio.fossil

Criará um arquivo meu_repositorio.fossil

## Clonar e Configurar o Repositório

Com este comando clonas para um diretório de trabalho:

    mkdir meu_projeto
    cd meu_projeto
    fossil open ../meu_repositorio.fossil

## Adicionar e Comitar Arquivos

Esses comandos adicionam todos os arquivos no diretório atual e 
fazem o primeiro commit com a mensagem "Primeiro commit".

    fossil add .
    fossil commit -m "Primeiro commit"

## Iniciar o Servidor Web do Fossil

O Fossil possui um servidor web embutido que permite visualização do repositório via navegador. 
Para iniciar o servidor, use:

    fossil ui meu_repositorio.fossil

## Trabalhar com Branches e Merges

    fossil branch new nome_branch
Para mesclar (merge) mudanças entre branches:

    fossil merge nome_branch

## Comandos Básicos do Fossil

status do repositório:

    fossil status

Atualizar o diretório:

    fossil update

Visualizar o histórico de commits:

    fossil timeline

## Hospedagem e Compartilhamento

O Fossil pode ser configurado para rodar como um servidor web completo para 
hospedar o repositório e facilitar o compartilhamento entre membros da equipe:

    fossil server --port 8080

Esse comando inicia um servidor na porta 8080. 
Outros desenvolvedores podem clonar o repositório via HTTP.

## Integração com Ferramentas Externas

O Fossil é autossuficiente, mas também pode ser integrado a IDEs e 
outras ferramentas para fornecer um fluxo de trabalho mais familiar 
e recursos adicionais, como editores de texto ou ferramentas de CI/CD.



### Implementação de Pipeline CI/CD para Build & Test da solução

Desenvolveu-se a seguinte pipeline para Build & Test da solução. 

Esta pipeline pode ser melhorada com a colocação de publishing, deploy automático e outras funcionalidades.

    name: Java CI with Maven
    
    on:
    push:
    branches: [ "main" ]
    pull_request:
    branches: [ "main" ]
    
    jobs:
    build:
    
        runs-on: ubuntu-latest
    
        steps:
        - uses: actions/checkout@v4
        - name: Set up JDK 17
          uses: actions/setup-java@v4
          with:
            java-version: '17'
            distribution: 'temurin'
            cache: maven
        - name: Build with Maven
          run: mvn -B package --file CA1/part2/links/pom.xml
        - name: Run Tests
          run: mvn test --file CA1/part2/links/pom.xml


### Implementação Para eliminar artifacts com mais de 07 dias.

Este Pipeline, tem a finalidade de remover artefactos que ficam gerados após cada commit realizado. 
Este código será executado todos os dias às 07:00 da manhã.

    - name: Delete files
      run: |
      # Encontre e delete arquivos mais antigos que 7 dias
      find . -type f -name '*.log' -mtime +7 -exec rm -f {} \;
      - name: Commit and push changes
        run: |
        git config --global user.name "GitHub Action"
        git config --global user.email "action@github.com"
        git add .
        git commit -m "Deleted old files"
        git push
        env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}  # Utiliza o token automático gerado pelo GitHub Actions


Para concluir a parte 2, criou-se uma nova tag com os comandos já referidos acima, e fez-se pull da mesma para o repositório.


    $ git tag ca1-part2

    $ git push origin --tags