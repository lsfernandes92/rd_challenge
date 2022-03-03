class RateManagers
  DRAW_VALUE = 0

  attr_reader :managers

  def initialize(managers)
    @managers = managers
    sort_managers_by_customers_desc
  end

  def most_rated
    case @managers.count
    when 0
      DRAW_VALUE
    when 1
      first_manager.id
    else
      rate_managers(first_manager, second_manager)
    end
  end

  private

  def sort_managers_by_customers_desc
    @managers = @managers.sort { |manager| manager.customers_count }.reverse
  end

  def rate_managers(manager1, manager2)
    manager1.customers_count == manager2.customers_count ? DRAW_VALUE : manager1.id
  end

  def first_manager
    @managers.first
  end

  def second_manager
    @managers.first(2).last
  end
end
