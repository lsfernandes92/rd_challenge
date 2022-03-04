# frozen_string_literal: true

require 'byebug'
require_relative '../helpers/score_build_helper'
require_relative 'manager'
require_relative 'rate_managers'
require_relative './validators/manager_validator'
require_relative './validators/customer_validator'
require_relative './validators/absence_validator'

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
    validate_managers
    validate_customers
    validate_absents
    check_managers_availability
    check_most_rated_manager
  end

  private

  def validate_managers
    ManagerValidator.new(@managers).validate
  end

  def validate_customers
    CustomerValidator.new(@customers).validate
  end

  def validate_absents
    AbsenceValidator.new(@managers, @absent_managers).validate
  end

  def check_most_rated_manager
    RateManagers.new(check_for_working_managers).most_rated
  end

  def check_for_working_managers
    customers_attended = []
    working_managers = []

    @managers.each do |manager_id, manager_score|
      manager = Manager.new(manager_id, manager_score)
      customers_attended += manager.attend_customers(@customers.except(*customers_attended))
      working_managers << manager
    end

    working_managers
  end

  def check_managers_availability
    @managers = @managers.except(*@absent_managers)
  end
end
