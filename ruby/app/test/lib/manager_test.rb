require_relative '../test_helper'
require_relative '../../src/lib/manager'

class ManagerTests < Minitest::Test
  include BuildScoresHelper

  def setup
    @manager = Manager.new(60)
  end

  def test_when_is_being_creating
    assert_equal Integer, @manager.id.class
    assert_equal 60, @manager.score
    assert_equal [], @manager.customers_attended
  end

  def test_manager_should_attend_only_customers_within_his_score
    customers = sort_by_score(build_scores([90, 20, 70, 40, 60, 10]))

    @manager.attend_customers(customers)

    assert_equal [2, 4, 5, 6], @manager.customers_attended.sort
    assert_equal 4, @manager.customers_attended.count
  end

  def test_when_manager_has_no_customers_to_attend
    customers = sort_by_score(build_scores([61, 70, 100]))

    @manager.attend_customers(customers)

    assert_equal [], @manager.customers_attended
    assert_equal 0, @manager.customers_attended.count
  end

  def test_when_passing_an_empty_array_of_customers
    customers = build_scores([])

    @manager.attend_customers(customers)

    assert_equal [], @manager.customers_attended
    assert_equal 0, @manager.customers_attended.count
  end
end