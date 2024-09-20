require_relative '../test_helper'
require_relative '../../src/lib/customer_success_balancing'
require 'timeout'

class CustomerSuccessBalancingTest < Minitest::Test
  include ScoresBuildHelper

  def test_scenario_one
    balancer = CustomerSuccessBalancing.new(
      build_scores([60, 20, 95, 75]),
      build_scores([90, 20, 70, 40, 60, 10]),
      [2, 4]
    )
    assert_equal 1, balancer.execute
  end

  def test_scenario_two
    balancer = CustomerSuccessBalancing.new(
      build_scores([11, 21, 31, 3, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_three
    balancer = CustomerSuccessBalancing.new(
      build_scores(Array(1..999)),
      build_scores(Array.new(10000, 998)),
      [999]
    )
    result = Timeout.timeout(1.0) { balancer.execute }
    assert_equal 998, result
  end

  def test_scenario_four
    balancer = CustomerSuccessBalancing.new(
      build_scores([1, 2, 3, 4, 5, 6]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_five
    balancer = CustomerSuccessBalancing.new(
      build_scores([100, 2, 3, 6, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 1, balancer.execute
  end

  def test_scenario_six
    balancer = CustomerSuccessBalancing.new(
      build_scores([100, 99, 88, 3, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      [1, 3, 2]
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_seven
    balancer = CustomerSuccessBalancing.new(
      build_scores([100, 99, 88, 3, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      [4, 5, 6]
    )
    assert_equal 3, balancer.execute
  end

  def test_scenario_eight
    balancer = CustomerSuccessBalancing.new(
      build_scores([60, 40, 95, 75]),
      build_scores([90, 70, 20, 40, 60, 10]),
      [2, 4]
    )
    assert_equal 1, balancer.execute
  end

  def test_when_is_being_creating
    balancer = CustomerSuccessBalancing.new(
      build_scores([10, 20]),
      build_scores([10, 20]),
      []
    )

    assert_equal Array, balancer.managers.class
    assert_equal Manager, balancer.managers.first.class
    assert_equal({1=>10, 2=>20}, balancer.customers)
    assert_equal [], balancer.absent_managers
  end

  def test__with_validations__on_managers_attribute__validates_duplicate_score
    assert_raises(InvalidManagersCollectionError) do
      CustomerSuccessBalancing.new(
        build_scores([10, 10]),
        build_scores([1 , 2]),
        []
      )
      raise InvalidManagersCollectionError, 'Managers cannot have the same level.'
    end
  end

  def test__with_validations__on_managers_attribute__validates_exceeds_collection_count
    Manager.any_instance.stubs(:validate).returns(true)

    raised_error_message = assert_raises(InvalidManagersCollectionError) do
      CustomerSuccessBalancing.new(
        build_scores(Array.new(1000, 1)),
        build_scores([1 , 2]),
        []
      )
      raise InvalidManagersCollectionError, 'The managers collection exceeds the maximum limit of 999 managers.'
    end
  end
end
