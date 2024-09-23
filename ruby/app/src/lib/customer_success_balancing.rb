# frozen_string_literal: true

require_relative '../concerns/sortable'
require_relative '../validators/managers_collection_validator'
require_relative '../validators/customers_collection_validator'
require_relative '../validators/absence_managers_validator'
require_relative 'manager'
require_relative 'customer'
require_relative 'rate_managers'
require_relative 'process_managers_attendance'

class CustomerSuccessBalancing
  include Sortable
  include ActiveModel::Validations

  attr_reader :managers, :customers, :absent_managers

  validates_with AbsenceManagersValidator

  validates :managers, managers_collection: true
  validates :customers, customers_collection: true

  def initialize(managers, customers, absent_managers)
    @managers = set_managers(managers)
    @customers = set_customers(customers)
    @absent_managers = absent_managers
  end

  def execute
    validate
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

  def set_customers(customers)
    sorted_customers = sort_by_score(customers)

    sorted_customers.map do |id, score|
      Customer.new(id, score)
    end
  end

  def check_managers_availability
    @managers = @managers.reject do |manager|
      @absent_managers.include?(manager.id)
    end
  end

  def check_most_rated_manager = RateManagers.new(process_managers_attendance).most_rated

  def process_managers_attendance
    ProcessManagersAttendance.new(
      @managers,
      @customers
    ).process_managers_attendance
  end
end
