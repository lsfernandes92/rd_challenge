# Clarificações finais

O propósito desse documento é de:

* Deixar claro alguns detalhes que deixei em aberto
* Compartilhar alguns dos meus pensamentos e experiências que tive enquanto fazia o desafio
* Fornecer qualquer outra informação relevante

O propósito desse repositório é de elaborar um sistema que retorna o gerente que atende o maior número de clientes baseado em seu próprio nível e no tamanho do cliente que ele deve atender. Esse documento irá usar termos intercambiáveis para o gerente, que também pode ser chamado de "Customer Success" ou somente "CS", e que no contexto desse projeto eu tomei a liberdade de nomear de `Manager`. Para os clientes eu tomei a liberdade de nomea-los de `Customer`/"Customers". Com base nessas informações, uma empresa fictícia faria um plano de ação para contratar o `Manager` de um nível aproximado para os seus clientes. O projeto foi feito em Ruby e foi sugerido pela **RD Station** para uma vaga de desenvolvedor Rails. O escopo completo da aplicação é o seguinte: [RD Challenge](https://tech.rdstation.com/).

Para as pessoas que irão validar o projeto, sinta-se livre para explorar a projeto por si próprio. No entanto, para economizar tempo, aqui está uma pequena introdução das minhas principais classes no sistema:

## As classes de domínio

Fez sentido nomear essas classes pois, para mim, elas são as principais classes domínio do problema proposto. E na minha opinião, ao nomear essas classes eu faço com que o leitor atente-se a importancia delas dentro do sistema(visto que cada uma mereceu sua própria classe) e use isso para entender o mesmo.

* A classe `CustomerSuccessBalancing`, localizada dentro da pasta `ruby/app/src/lib/customer_success_balancing.rb`. Essa classe já era esperada que existisse, pois ela é instanciada nos testes iniciais. Essa classe, praticamente delega todo o trabalho para classes auxiliares por meio de composição. Essa classe também ficou responsável por fazer validações nos "inputs" iniciais das coleções de "Managers", "Customers" e "AbsentManagers".
* A classe `Customer`, localizada dentro da pasta `ruby/app/src/lib/customer.rb`. Essa classe ficou responsável por encapsular características do `Customer`. Essa abstração também me ajudou a validadar as regras mais específicas para cada `Customer`, como por exemplo, a validação das premissas "0 < id do cliente < 1.000.000" e "0 < tamanho do cliente < 100.000".
* A própria classe `Manager`, localizada dentro da pasta `ruby/app/src/lib/manager.rb`. Essa classe ficou responsável por encapsular características do `Manager`. Essa abstração também me ajudou a validadar as regras mais específicas para cada `Manager`, como por exemplo, a validação das premissas "0 < id do cs < 1.000" e "0 < nível do cs < 10.000".
*  A classe `ProcessManagersAttendance`, localizada em `ruby/app/src/lib/process_managers_attendance.rb`. Essa ficou responsável por fazer fazer a distribuição de qual "manager" ficaria responsável por qual "customer".
*  A classe `RateManagers`, localizada em `ruby/app/src/lib/rate_managers.rb`. Ela ficou responsável por avaliar e dar a resposta final esperada pelo desafio dizendo qual `Manager` é o mais adequado para o trabalho, assim como retornar "0" para casos de empate entre "Managers" ou caso nenhum `Manager` seja adequado para o trabalho.

## As classes de validação

As classes de validação podem serem encontradas dentro de `ruby/app/src/validators`. Aqui minha lógica foi de separar entre "validators" de coleção, como por exemplo, os arrays de "Managers", "Customers" e "AbsenceManagers" que são passados no momento da instanciação da classe `CustomerSuccessBalancing`, e "validators" de objetos individuais(`Manager` e `Customer`). Desse jeito achei que ficou bem organizado onde é feito cada tipo de validação, como resultado tenho classes de validação mais focadas e validações mais fáceis de serem testadas.

Para as validações usei a gem `activemodel` simplesmente por estar mais acostumado com a aplicação e uso dela, visto que a mesma é muito usada em aplicações que utilizam o framework Rails.

## As classes auxiliares

Esses módulos, ou também chamados de mixins se tornam necessário pois mantém o código mais modular e organizado, e promove a reutilização de código em várias classes e testes.

### Concerns

* O mixin `Sortable`, localizado em `ruby/app/src/concerns/sortable.rb`. Esse mixin é responsável por prover métodos de ordenação utilizado para ordenar "Managers" e "Customers". Um ponto importante aqui é de que esses métodos de ordenação faz a conversão de uma coleção de hashes em um único hash, onde o valor da chave `:id` de cada hash individual se torna a chave no novo hash, e o valor da chave `:score` se torna o valor correspondente. Como por exemplo:

```ruby
>> build_scores([60, 20, 95, 75])
=> [{:id=>1, :score=>60}, {:id=>2, :score=>20}, {:id=>3, :score=>95}, {:id=>4, :score=>75}]

>> sort_by_score(build_scores([60, 20, 95, 75]))
=> {2=>20, 1=>60, 4=>75, 3=>95}
```

Por que fiz isso? Só porque achei mais fácil de trabalhar dessa forma.

Por que fiz os métodos de ordenação? Porque olhando os teste do `CustomerSuccessBalancingTest` e mais especificamente o cenário `test_scenario_seven`, notei que para ter o resultado esperado eu precisa de uma ordenação nos managers. 
  
### Test helpers

* Os mixins `SetCustomersHelper` e `SetManagersHelper`, localizados em `ruby/test/helpers/set_customers_helper.rb` e `ruby/test/helpers/set_managers_helper.rb` respectivamente. Feitos exclusivamente para serem utilizados nos testes. Por se tratar de teste unitários, eles se tornam necessário pois algumas classes esperam que os "Customers" e "Managers" sejam passados para elas como parametros de forma específica.
* O mixin `ScoresBuildHelper`, localizado dentro de `ruby/test/helpers/scores_build_helper.rb`. Esse helper estava presente como método privado dentro da classe de teste inicialmente provida pelo desafio. Tomei a liberdade de renomea-lo e extrair para esse helper por conta da reutilização em outras classes de teste.

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

Antes de começar, tenha certeza que uma tenha versão do Ruby instalada em sua máquina. Para conferir se o ruby está instalado em sua máquina rode o comando `$ ruby -v` no terminal. O comando deverá retornar algo como:

`$ ruby 3.2.4 (2024-04-23 revision af471c0e01) [arm64-darwin23]`

Caso o Ruby não esteja instalado você pode seguir [esse](https://gorails.com/setup/ubuntu/17.10#ruby) guia de instalação do Ruby do site GoRails.

### Bundler

Bundler é um consistente gerenciador de dependências para projetos Ruby. Esse gerenciador é responsável por rastrear e instalar essas dependências de acordo com as versões necessárias para o projeto.

Ele é uma saida para da "dependency hell", e garante que as gems necessárias estejam presentes no ambiente de desenvolvimento, homologação e produção.

Para começar a trabalhar com um projeto com Bundler, basta rodar o comando `bundle install`.

Qualquer distribuição moderna do Ruby já vem com o Bundler pré-instalado por padrão, mas ainda assim ele é um pré-requisito.

## Clonando a aplicação

_Obs: Aqui vou assumir que o Git já esteja instalado e configurado na máquina._

Para isso, abra o terminal, clone a aplicação utilizando o
[Git](https://git-scm.com/book/pt-br/v1/Primeiros-passos-Instalando-Git), e navegue até pasta do projeto feito em ruby.

```shell
$ git clone git@github.com:lsfernandes92/rd_challenge.git
$ cd rd_challenge/ruby/
```

## :warning: Mudando para a branch de solução completa

Para não fazer commits na "branch" `main` e trabalhar com "feature branches" criei, a partir da "branch" `main`, uma "branch" chamada `complete-solution` e a partir dela fui criando outras "feature branches". Ao finalizar cada "feature branch" eu mergiei na "branch" `complete-solution`. Então antes de mais nada, após clonar a aplicação, faça "checkout" para a "branch" `complete-solution` que contém toda a solução. Para isso, ainda dentro da pasta `/ruby` rode o seguinte comando:

```shell
$ git checkout complete-solution
```

## Instalando as dependências

Ainda dentro da pasta `/ruby` rode o seguinte comando para instalar as dependências do projeto:

```shell
$ bundle install
```

## Como rodar os testes

Para os testes foi utilizado o `MiniTest` e para executar os mesmos execute o comando:

```shell
$ for file in test/*.rb AND test/*/*.rb; do ruby $file -v; done
```

Ou rode o comando para cada classe de teste presente neste projeto com o comando:

```shell
$ ruby app/test/lib/<NOME_DA_CLASSE>_test.rb
```

Ou ainda, para rodar cenários específicos rode o seguinte comando:

```shell
$ ruby app/test/lib/<NOME_DA_CLASSE>_test.rb -n <NOME_DO_CENARIO_DE_TESTE>
```

Exemplo de saída:

```shell
Started with run options -v --seed 50479

Finished in 0.00022s
0 tests, 0 assertions, 0 failures, 0 errors, 0 skips
ruby: No such file or directory -- AND (LoadError)
Started with run options -v --seed 48002

CustomerSuccessBalancingTest
  test_scenario_three                                             PASS (0.99s)
  test_scenario_five                                              PASS (0.00s)
  test_scenario_one                                               PASS (0.00s)
  test_scenario_two                                               PASS (0.00s)
  test__with_validations__on_managers_attribute__validates_duplicate_score PASS (0.00s)
  test__with_validations__on_absence_customers_attribute__validates_absence_limit PASS (0.00s)
  test_scenario_eight                                             PASS (0.00s)
  test_when_is_being_creating                                     PASS (0.00s)
  test__with_validations__on_customers_attribute__validates_exceed_collection_count PASS (4.48s)
  test_scenario_six                                               PASS (0.00s)
  test_scenario_seven                                             PASS (0.00s)
  test_scenario_four                                              PASS (0.00s)
  test__with_validations__on_managers_attribute__validates_exceeds_collection_count PASS (0.00s)

Finished in 5.47860s
13 tests, 25 assertions, 0 failures, 0 errors, 0 skips
Started with run options -v --seed 1920

CustomerTest
  test__with_validations__on_id_attribute__validates_min_range    PASS (0.01s)
  test__with_validations__on_score_attribute__validates_min_range PASS (0.00s)
  test__with_validations__on_id_attribute__validates_type         PASS (0.00s)
  test_when_is_being_creating                                     PASS (0.00s)
  test__with_validations__on_score_attribute__validates_max_range PASS (0.00s)
  test__with_validations__on_score_attribute__validates_type      PASS (0.00s)
  test__with_validations__on_id_attribute__validates_max_range    PASS (0.00s)

Finished in 0.00682s
7 tests, 20 assertions, 0 failures, 0 errors, 0 skips
Started with run options -v --seed 60690

ManagerTest
  test_when_is_being_creating                                     PASS (0.00s)
  test__with_validations__on_score_attribute__validates_min_range PASS (0.00s)
  test__with_validations__on_id_attribute__validates_min_range    PASS (0.00s)
  test__with_validations__on_score_attribute__validates_max_range PASS (0.00s)
  test__with_validations__on_id_attribute__validates_type         PASS (0.00s)
  test__when_manager_has_no_customers_to_attend__returns_empty_customers_attended_id PASS (0.00s)
  test_manager_should_attend_only_customers_within_his_score      PASS (0.00s)
  test__when_passing_an_empty_array_of_customers__returns_empty_customers_attended_id PASS (0.00s)
  test__with_validations__on_score_attribute__validates_type      PASS (0.00s)
  test__with_validations__on_id_attribute__validates_max_range    PASS (0.00s)

Finished in 0.00589s
10 tests, 27 assertions, 0 failures, 0 errors, 0 skips
Started with run options -v --seed 62068

ProcessManagersAttendanceTest
  test__when_has_no_customer_to_attend__returns_managers_without_customers_attended PASS (0.01s)
  test__when_has_no_customer__returns_managers_without_customers_attended PASS (0.00s)
  test_assign_customers_to_managers                               PASS (0.00s)
  test__when_has_no_manager__returns_empty_array                  PASS (0.00s)
  test_when_is_being_creating                                     PASS (0.00s)

Finished in 0.00578s
5 tests, 11 assertions, 0 failures, 0 errors, 0 skips
Started with run options -v --seed 39119

RateManagersTest
  test__when_has_only_one_manager_without_attended_customers__most_rated_should_be_0 PASS (0.01s)
  test_when_is_being_creating                                     PASS (0.00s)
  test__when_two_managers_has_the_same_customers_attended_count__most_rated_should_be_0 PASS (0.00s)
  test_managers_should_be_sorted_by_attented_customers            PASS (0.00s)
  test__when_two_managers_has_different_attended_customers_count__returns_most_rated_manager_id PASS (0.00s)
  test__when_has_no_manager__most_rated_should_be_0               PASS (0.00s)
  test__when_has_only_one_manager__most_rated_should_be_itself    PASS (0.00s)

Finished in 0.00575s
7 tests, 10 assertions, 0 failures, 0 errors, 0 skips
```

## Observações

1. Tomei a liberdade de incrementar os teste da classe `CustomerSuccessBalancing`, mas não alterei os teste originais.
2. O projeto inicial continha pastas para soluções em outras linguagens. Tomei a liberdade de exclui-las e deixar somente a pasta para a solução na linguagem Ruby.
3. Usei bastante um recurso do Ruby, novo para mim, chamado "endless methods". Normalmente não usaria, mas achei esse artigo(citado na seção de [referências](#referencias) que utiliza de uma forma interessante. Como uma forma de mostrar que me mantenho atualizado, resolvi colocar em prática nesse projeto :). Achei que o "endless methods" são bem úteis para métodos que só tem uma linha, ou para métodos predicados, e/ou por último achei bem legal por manter o código junto(tipo quando um método chama outro método e esse outro método é declarado logo em seguida por questões de manter o código junto). Então não se assuste com a sintaxe.

## Melhorias futuras

* Tenho pouca experiência com o `Minitest`, assim como também não tenho muita noção das melhores práticas. Então em algum momento revisitaria os testes para uma refatoração.
* A minha solução fez com que o cenário de teste `test_scenario_three` da classe `CustomerSuccessBalancingTest` ficasse instável. Creio que isso se deve ao fato da lógica de "setar" os "Managers" e "Customers" dentro da classe `CustomerSuccessBalancing`. Então em algum momento revisitaria essa lógica para fazer algo mais performático.

## Referencias

* [RubyGems](https://rubygems.org/)
* [Endless method - A quick intro](https://allaboutcoding.ghinda.com/endless-method-a-quick-intro)
* [Active Record Validations do Rails guides](https://guides.rubyonrails.org/active_record_validations.html#custom-methods)
* [Rubocop gem](https://rubocop.org/)
* [Guia que usei de referência para os testes](https://minitest.rubystyle.guide/#introduction)
* [Documentação da classe Array que usei para consulta](https://ruby-doc.org/core-2.7.0/Array.html)
* [Documentação da classe Hash que usei para consulta](https://ruby-doc.org/core-3.1.0/Hash.html)