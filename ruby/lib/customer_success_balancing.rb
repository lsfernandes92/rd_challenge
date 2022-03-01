require 'byebug'

class CustomerSuccessBalancing
  def initialize(customers_success, customers, away_customers_success)
    @customers_success = customers_success
    @customers = customers
    @away_customers_success = away_customers_success
  end

  # Returns the ID of the customer success with most customers
  def execute
    # TODO:
    # => Drop dos gerente away da array de gerentes disponiveis
    # => Ordenar array de gerentes disponiveis
    # => Para cada gerente do array de gerentes disponveis verificar
    # se tem algum cliente no nível menor ou igual ao dele
    #   => Se tiver atribuir a ele
    # => Repetir o passo 3 até chegar o ultimo gerente disponivel do
    # array de gerente disponiveis
    @away_customers_success.each do |cs|
      @customers_success.delete_at(cs - 1)
    end
  end
end
