require_relative '../concerns/sortable'
require_relative 'manager'
require_relative 'rate_managers'

class CustomerSuccessBalancing
  include Sortable
  
  def initialize(managers, customers, absent_managers)
    @managers = set_managers(managers)
    @customers = sort_by_score(customers)
    @absent_managers = absent_managers
  end

  def execute
    check_managers_availability
    check_most_rated_manager
  end

  private

  def set_managers(managers)
    sorted_managers = sort_by_score(managers)

    sorted_managers.map do |id, score|
      Manager.new(id, score)
    end
  end

  def check_managers_availability
    @managers = @managers.reject do |manager|
      @absent_managers.include?(manager.id)
    end
  end

  def check_most_rated_manager
    RateManagers.new(working_managers).most_rated
  end

  def working_managers
    customers_attended = []
    working_managers = []

    @managers.each do |manager|
      customers_attended += manager.attend_customers(@customers.except(*customers_attended))
      working_managers << manager
    end

    working_managers
  end
end