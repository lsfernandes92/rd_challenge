require_relative '../../src/concerns/sortable'
require_relative '../../src/lib/manager'

module SetManagersHelper
  include Sortable

  def set_managers(managers)
    sorted_managers = sort_by_score(managers)

    sorted_managers.map do |id, score|
      Manager.new(id, score)
    end
  end
end