# RD Challenge

O propósito desse repositório é de elaborar um sistema que retorna o gerente, chamado também de _customer success_ ou somente _CS_, que atende o maior número de clientes baseado em seu nível e no tamanho do cliente. E que com base nessa informação a empresa ficticia poderá fazer um plano de ação para contratar mais _CS’s_ de um nível aproximado. O projeto foi feito em Ruby e foi sugerido pela RD Station para uma vaga de desenvolvedor Rails. O escopo da aplicação é o seguinte: [RD Challenge](https://tech.rdstation.com/).

As principais classes de modelo do negócio que identifiquei foram as: claro, a já proposta no desafio `CustomerSuccessBalancing`, a `Manager` e a `RateManagers`. Antes mesmo de criar as classes `Manager` e `RateManagers` progredi com o projeto fazendo tudo dentro da classe `CustomerSuccessBalancing`. Devido a minha lógica para resolver, a classe `CustomerSuccessBalancing` resultou em uma grande quantidade de linhas e com métodos longos e que faziam mais de uma coisa.

Com a necessidade foi então criada a classe `Manager` responsável por guardar informações de um gerente em forma de um objeto quando necessário a instanciação. Também a classe `Manager` ficou responsável por responder com a quantidade de clientes que um gerente pode atender através do método `.attend_customers`.

A outra necessidade que identifiquei foi a de encapsular a regras que determinam, a partir de uma lista de gerentes, qual o gerente mais cotado e que atende o maior número de clientes. E quem detém para si essa lógica é a classe `RateManagers`. Essa classe também ficou responsável por retornar um `DRAW_VALUE` em casos de empate entre dois gerentes.

Dessa forma consegui "dar nome" para tudo aquilo que identifiquei, como uma interface auxiliar. Com isso também deixei a classe `CustomerSuccessBalancing` fazendo coisas mais focadas e pedindo a ajuda para essas abstrações para realizar determinadas tarefas, que ao meu ver, fugia um pouco do escopo da `CustomerSuccessBalancing`.

Parar validar algumas das premissas do desafio utilizei a gem [dry-validation](https://dry-rb.org/gems/dry-validation/1.8/). Essa gem ficou responsável por fazer tais validações através de objetos chamados de _contracts_ e são nessas classes de contrato que acontece algumas das validações em cima dos inputs _customer_ e _custumer success_. Como por exemplo, a validação das premissas:
* 0 < id do cs < 1.000
* 0 < id do cliente < 1.000.000
* 0 < nível do cs < 10.000
* 0 < tamanho do cliente < 100.000

Em conjunto foi utilizado classes que nomiei como _validators_ e que tem por responsabilidade fazer algumas dessas validações com a ajuda das classes de _contract_. Portanto, a classe `CustomerSuccessBalancing` utiliza, por meio de composição, a ajuda dessas classes de _validators_ para assim validar principalmente os _customers_, _CS's_ e _absents CS's_.

Escopos concluídos(ou que acho que completei xD):

## MVP
Sobre as principais funcionalidades:
- [x] Retornar o ID do _CS_ que mais atende clientes
- [x] Retornar 0 em casos de empate
- [x] Levar em conta os _CS's_ que estão ausentes no momento de distribuir os clientes
- [x] Levar em conta o nível do _CS_ mais adequado para o tamanho do cliente

Sobre as premissas concluídas:
- [x] Todos os CSs têm níveis diferentes
- [x] Não há limite de clientes por CS
- [x] Clientes podem ficar sem serem atendidos
- [x] Clientes podem ter o mesmo tamanho
- [x] 0 < n < 1.000
- [x] 0 < m < 1.000.000
- [x] 0 < id do cs < 1.000
- [x] 0 < id do cliente < 1.000.000
- [x] 0 < nível do cs < 10.000
- [x] 0 < tamanho do cliente < 100.000
- [x] Valor máximo de t = n/2 arredondado para baixo

## Pré-requisitos

### Instalação do Ruby

Antes de começar, tenha certeza que uma versão do Ruby instalada em sua máquina. Para conferir se o ruby está instalado em sua máquina utilize `$ ruby -v`. O comando deverá retornar algo como:

`$ ruby 3.0.0p0 (2020-12-25 revision 95aff21468) [x86_64-linux]`

Caso o Ruby não esteja instalado vc pode seguir [esse](https://gorails.com/setup/ubuntu/17.10#ruby) guia de instalação do Ruby do site GoRails.

### Bundler

Bundler é um consistente gerenciador de dependências para projetos Ruby. Esse gerenciador é responsável por rastrear e instalar essas dependências de acordo com as versões necessárias para o projeto.

Ele é uma saida para da "dependency hell", e garante que as gems necessárias estejam presentes no ambiente de desenvolvimento, homologação e produção.
Para começar a trabalhar com um projeto com bundler basta somente rodar o comando `bundle install`.

O guia da instalação do Ruby passou pelo passo de instalação do bundler quando pediu para rodar o comando `gem install bundler`.

## Clonando a aplicação

Para isso abra o terminal, clone a aplicação utilizando o [Git](https://git-scm.com/book/pt-br/v1/Primeiros-passos-Instalando-Git) e navegue até pasta do projeto feito em ruby:

```shell
$ git clone git@github.com:lsfernandes92/rd_challenge.git
$ cd rd_challenge/ruby/
```

## Como rodar os testes

Para os testes foi utilizado o MiniTest e para executar os mesmos execute o comando:

```shell
$ for file in test/*.rb AND test/*/*.rb; do ruby $file -v; done
```

Ou rode o comando para cada classe de teste presente neste projeto com o comandos

```shell
$ ruby test/<NOME_DA_CLASSE>_test.rb
```

Exemplo de saída
```shell
Run options: -v --seed 59489

# Running:

CustomerSuccessBalancingTests#test_scenario_four = 0.00 s = .
CustomerSuccessBalancingTests#test_scenario_two = 0.00 s = .
CustomerSuccessBalancingTests#test_scenario_five = 0.00 s = .
CustomerSuccessBalancingTests#test_scenario_six = 0.00 s = .
CustomerSuccessBalancingTests#test_scenario_three = 0.61 s = .
CustomerSuccessBalancingTests#test_scenario_one = 0.00 s = .
CustomerSuccessBalancingTests#test_scenario_seven = 0.00 s = .

Finished in 0.617277s, 11.3401 runs/s, 11.3401 assertions/s.
7 runs, 7 assertions, 0 failures, 0 errors, 0 skips
Run options: -v --seed 63588

# Running:

ManagerTests#test_manager_should_attend_only_customers_within_his_score = 0.00 s = .
ManagerTests#test_when_is_being_creating = 0.00 s = .
ManagerTests#test_when_manager_has_no_customers_to_attend = 0.00 s = .

Finished in 0.002478s, 1210.8204 runs/s, 2825.2475 assertions/s.
3 runs, 7 assertions, 0 failures, 0 errors, 0 skips
Run options: -v --seed 60893

# Running:

RateManagersTests#test_when_two_managers_has_different_customers_count = 0.00 s = .
RateManagersTests#test_when_has_one_manager_most_rated_should_be_itself = 0.00 s = .
RateManagersTests#test_when_is_being_creating = 0.00 s = .
RateManagersTests#test_when_has_no_manager_most_rated_should_be_0 = 0.00 s = .
RateManagersTests#test_managers_should_be_sorted_by_clients = 0.00 s = .
RateManagersTests#test_when_two_managers_has_the_same_customers_count = 0.00 s = .

Finished in 0.002398s, 2501.6699 runs/s, 2501.6699 assertions/s.
6 runs, 6 assertions, 0 failures, 0 errors, 0 skips
```

## Observações

1. Tive que mudar o teste `test_scenario_five` da classe `CustomerSuccessBalancingTests` pois ele ia em desavença com uma premissa que era pedido no desafio, a que dizia "Todos os CSs têm níveis diferentes". Realizei a mudança justamente por esse teste instanciar a classe `CustomerSuccessBalancing` passando Cs's com níveis iguais e o que era esperado para o teste passar era o ID de um _CS_ e não uma mensagem de erro alertando sobre os _CS's_ de níveis iguais. Outro teste para validar que todos _CS's_ passados tivessem de fato níveis difentes foi adicionado para suprir a premissa. A mudança pode ser vista nesse commit [aqui](https://github.com/lsfernandes92/rd_challenge/commit/e3651d205a38ccec38db33f219aa7e902a7d4760).

2. Em vez de criar minhas próprias classes de validação, por conveniência utilizei da ajuda da gem "dry-validation". Apesar de fugir um pouco da implementação "purista" achei melhor não reinventar a roda. Não só isso, mas acho que gem também trouxe uma melhor organização no código.

## Melhorias futuas

* Uma forma mais inteligente de saber quais clientes o CS atende. Do jeito que está hoje o gerente para saber quais clientes atende, através do método `.attend_customers`, necessariamente irá percorrer a lista inteira de clientes passada para ele. Mesmo que os níveis dos clientes sejam maior que o nível de experiência do _CS_.
* Optei pela simplicidade, mas acho que a gem do factory bot ajudaria nos testes
* Até hoje só tinha utilizado o RSpec como framework de teste e não tenho experiência com o Minitest, assim também não tenho muita noção das melhores práticas. Então em algum momento revisitaria os testes para uma refatoração.
* Fiquei com um pouco de dúvida se fazia sentido o método `.check_for_working_managers` ficar dentro da classe `CustomerSuccessBalancing`. Talvez revisitaria isso também.

## Referencias

* [Rubocop basic usage](https://docs.rubocop.org/rubocop/usage/basic_usage.html)
* [Guia que usei de referência para os testes](https://minitest.rubystyle.guide/#introduction)
* [Página de introduçao do dry-validation](https://dry-rb.org/gems/dry-validation/1.8/)
* [RubyGems - onde pesquise as gem's utilizada nesse projeto](https://rubygems.org/)
* [Documentação da classe Array que usei para consulta](https://ruby-doc.org/core-2.7.0/Array.html)
* [Documentação da classe Hash que usei para consulta](https://ruby-doc.org/core-3.1.0/Hash.html)
