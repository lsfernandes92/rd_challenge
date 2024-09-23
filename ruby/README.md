# RD Challenge

<INTRODUCAO_AO_PROJETO>

## MVP
Sobre as principais funcionalidades:
- [ ] Retornar o ID do _CS_ que mais atende clientes
- [ ] Retornar 0 em casos de empate
- [ ] Levar em conta os _CS's_ que estão ausentes no momento de distribuir os clientes
- [ ] Levar em conta o nível do _CS_ mais adequado para o tamanho do cliente

Sobre as premissas concluídas:
- [ ] Todos os CSs têm níveis diferentes
- [ ] Não há limite de clientes por CS
- [ ] Clientes podem ficar sem serem atendidos
- [ ] Clientes podem ter o mesmo tamanho
- [ ] 0 < n < 1.000
- [ ] 0 < m < 1.000.000
- [ ] 0 < id do cs < 1.000
- [ ] 0 < id do cliente < 1.000.000
- [ ] 0 < nível do cs < 10.000
- [ ] 0 < tamanho do cliente < 100.000
- [ ] Valor máximo de t = n/2 arredondado para baixo

## Pré-requisitos

### Instalação do Ruby

### Bundler

## Clonando a aplicação

_Obs: Aqui vou assumir que o Git já esteja instalado e configurado na máquina._

Para isso, abra o terminal, clone a aplicação utilizando o
[Git](https://git-scm.com/book/pt-br/v1/Primeiros-passos-Instalando-Git), e navegue até pasta do projeto feito em ruby e
mude para a branch `complete-solution` utilizando os seguintes comandos:

```shell
$ git clone git@github.com:lsfernandes92/rd_challenge.git
$ cd rd_challenge/ruby/
$ git checkout complete-solution
```

## Instalando as dependências

Ainda dentro da pasta `/ruby` rode o seguinte comando para instalar as dependências do projeto:

```shell
$ bundle install
```

## Como rodar os testes

Exemplo de saída:

## Observações

## Melhorias futuas

## Referencias

* [RubyGems](https://rubygems.org/)
* [Endless method - A quick intro](https://allaboutcoding.ghinda.com/endless-method-a-quick-intro)
* [Active Record Validations do Rails guides](https://guides.rubyonrails.org/active_record_validations.html#custom-methods)
* [Rubocop gem](https://rubocop.org/)