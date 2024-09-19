class RateManagers
  DRAW_VALUE = 0

  attr_reader :managers

  def initialize(managers)
    @managers = sort_managers_by_attended_customers_descending(managers)
  end

  def most_rated
    case @managers.count
    when 0
      DRAW_VALUE
    when 1
      first_manager.customers_attended.count > 0 ? first_manager.id : DRAW_VALUE
    else
      rate_managers(first_manager, second_manager)
    end
  end

  private

  def sort_managers_by_attended_customers_descending(managers)
    managers.sort_by { |manager| manager.customers_attended.count }.reverse
  end

  def rate_managers(manager1, manager2)
    manager1.customers_attended.count == manager2.customers_attended.count ? DRAW_VALUE : manager1.id
  end

  def first_manager
    @managers.first
  end

  def second_manager
    @managers.first(2).last
  end
end