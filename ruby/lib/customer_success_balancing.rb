# frozen_string_literal: true

require 'byebug'
require_relative '../helpers/score_build_helper'
require_relative 'manager'
require_relative 'rate_managers'

class CustomerSuccessBalancing
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
    customers_attended = []
    working_managers = []

    @managers.each do |manager_id, manager_score|
      manager = Manager.new(manager_id, manager_score)
      customers_attended += manager.attend_customers(@customers.except(*customers_attended))
      working_managers << manager
    end

    RateManagers.new(working_managers).most_rated
  end

  def check_managers_availability
    @managers = @managers.except(*@absent_managers)
  end
end
