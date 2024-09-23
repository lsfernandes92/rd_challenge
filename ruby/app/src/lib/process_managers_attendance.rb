# frozen_string_literal: true

class ProcessManagersAttendance
  attr_reader :managers, :customers

  def initialize(managers, customers)
    @managers = managers
    @customers = customers
  end

  def process_managers_attendance
    already_attended_customers_id = []
    managers_attendance = []

    @managers.each do |manager|
      already_attended_customers_id += manager.attend_customers(available_customers(already_attended_customers_id))
      managers_attendance << manager
    end

    managers_attendance
  end

  private

  def available_customers(already_attended_customers_id)
    @customers.reject do |customer|
      already_attended_customers_id.include?(customer.id)
    end
  end
end
