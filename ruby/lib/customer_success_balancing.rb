require 'byebug'
require_relative '../helpers/score_build_helper'

class CustomerSuccessBalancing
  DRAW_CASE_VALUE = 0

  include ScoreBuildHelper

  def initialize(managers, customers, absent_managers)
    @managers = managers
    @customers = customers
    @absent_managers = absent_managers

    @managers = sort_by_score(@managers)
    @customers = sort_by_score(@customers)
  end

  def execute
    check_managers_availability
    check_most_rated_manager
  end

  private

  def check_most_rated_manager
    preffered_manager = 1
    customers_attended = []
    max_customers_attended = 0

    @managers.each do |manager_id, manager_score|
      manager_clients = 0

      @customers.except(*customers_attended).each do |customer_id, customer_score|
        if valid_customer_for_manager?(manager_score, customer_score)
          customers_attended << customer_id
          manager_clients += 1
        end
      end

      if most_rated_manager?(manager_clients, max_customers_attended)
        max_customers_attended = manager_clients
        preffered_manager = manager_id
      elsif draw_case?(manager_clients, max_customers_attended)
        preffered_manager = DRAW_CASE_VALUE
      end
    end

    preffered_manager
  end

  private

  def valid_customer_for_manager?(manager_score, customer_score)
    manager_score >= customer_score
  end

  def most_rated_manager?(clients, max_customers_attended)
    clients > max_customers_attended
  end

  def draw_case?(clients, max_customers_attended)
    clients == max_customers_attended
  end

  def check_managers_availability
    @managers = @managers.except(*@absent_managers)
  end
end
