require_relative '../test_helper'
require_relative '../../src/lib/manager'
require_relative '../../src/lib/rate_managers'

class RateManagersTest < Minitest::Test
  include ScoresBuildHelper

  def setup
    @manager = Manager.new(20)
    @manager_list = []
    @manager_list << @manager
    @rate_managers = RateManagers.new(@manager_list)
  end

  def test_when_is_being_creating
    assert_equal 1, @rate_managers.managers.count
    assert_equal @manager, @rate_managers.managers.first
  end

  def test_managers_should_be_sorted_by_attented_customers
    customers = sort_by_score(build_scores([90, 20, 70, 40, 60, 10]))
    manager_with_most_clients = Manager.new(60)

    manager_with_most_clients.attend_customers(customers)
    @manager_list << manager_with_most_clients

    rate_managers = RateManagers.new(@manager_list)

    assert_equal 2, rate_managers.managers.count
    assert_equal manager_with_most_clients, rate_managers.managers.first
  end

  def test_when_has_no_manager__most_rated_should_be_0
    rate_managers = RateManagers.new([])

    assert_equal 0, rate_managers.most_rated
  end

  def test_when_has_only_one_manager__most_rated_should_be_itself
    customers = sort_by_score(build_scores([20]))

    @manager.attend_customers(customers)

    assert_equal @manager.id, @rate_managers.most_rated
  end

  def test_when_has_only_one_manager_without_attended_customers__most_rated_should_be_0
    assert_equal 0, @rate_managers.most_rated
  end

  def test_when_two_managers_has_the_same_customers_attended_count__most_rated_should_be_0
    customers = sort_by_score(build_scores([10, 20]))
    another_manager = Manager.new(60)

    @manager.attend_customers(customers)
    another_manager.attend_customers(customers)

    rate_managers = RateManagers.new([@manager, another_manager])

    assert_equal 0, rate_managers.most_rated
  end

  def test_when_two_managers_has_different_attended_customers_count__returns_most_rated_manager_id
    customers = sort_by_score(build_scores([10, 21, 31]))
    another_manager = Manager.new(60)

    @manager.attend_customers(customers)
    another_manager.attend_customers(customers)

    rate_managers = RateManagers.new([@manager, another_manager])

    assert_equal another_manager.id, rate_managers.most_rated
  end
end