require_relative '../../src/concerns/sortable'
require_relative '../../src/lib/customer'

module SetCustomersHelper
  include Sortable

  def set_customers(customers)
    sorted_customers = sort_by_score(customers)

    sorted_customers.map do |id, score|
      Customer.new(id, score)
    end
  end
end