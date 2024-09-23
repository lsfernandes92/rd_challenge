# frozen_string_literal: true

require_relative '../concerns/sortable'
class RateManagers
  include Sortable

  DRAW_VALUE = 0

  attr_reader :managers

  def initialize(managers)
    @managers = sort_managers_by_attended_customers_descending(managers)
  end

  def most_rated = case @managers.count
                   when 0 then DRAW_VALUE
                   when 1 then first_manager_has_attended_customers? ? first_manager.id : DRAW_VALUE
                   else rate_managers(first_manager, second_manager)
                   end

  private

  def first_manager_has_attended_customers? = first_manager.customers_attended_id.count.positive?

  def rate_managers(manager1, manager2)
    draw_case?(manager1, manager2) ? DRAW_VALUE : manager1.id
  end
  def draw_case?(manager1, manager2) = manager1.customers_attended_id.count == manager2.customers_attended_id.count

  def first_manager = @managers.first
  def second_manager = @managers.first(2).last
end
