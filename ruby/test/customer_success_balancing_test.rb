# frozen_string_literal: true

require 'minitest/autorun'
require 'timeout'
require_relative '../lib/customer_success_balancing'
require_relative '../helpers/score_build_helper'

class CustomerSuccessBalancingTests < Minitest::Test
  include ScoreBuildHelper

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
      build_scores(Array.new(10_000, 998)),
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
      build_scores([100, 2, 3, 4, 5]),
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

  def test_when_has_duplicate_level_managers
    balancer = CustomerSuccessBalancing.new(
      build_scores([100, 2, 3, 3, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    exception = assert_raises(RuntimeError) { balancer.execute }
    assert_match(/It must not have managers with the same level!/, exception.message)
  end

  def test_when_managers_input_exceeds_the_count_999
    balancer = CustomerSuccessBalancing.new(
      build_scores(Array(1..1000)),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    exception = assert_raises(RuntimeError) { balancer.execute }
    assert_match(/The managers collection exceeds the limit of 999 managers/, exception.message)
  end

  def test_manager_id_input_min_limit
    balancer = CustomerSuccessBalancing.new(
      [{ id: 0, score: 2 }],
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    exception = assert_raises(RuntimeError) { balancer.execute }
    assert_match(/id must be between 1 and 999/, exception.message)
  end

  def test_manager_id_input_max_limit
    balancer = CustomerSuccessBalancing.new(
      [{ id: 1000, score: 2 }],
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    exception = assert_raises(RuntimeError) { balancer.execute }
    assert_match(/id must be between 1 and 999/, exception.message)
  end

  def test_manager_score_input_min_limit
    balancer = CustomerSuccessBalancing.new(
      [{ id: 1, score: 0 }],
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    exception = assert_raises(RuntimeError) { balancer.execute }
    assert_match(/score must be between 1 and 999/, exception.message)
  end

  def test_manager_score_input_max_limit
    balancer = CustomerSuccessBalancing.new(
      [{ id: 1, score: 10_000 }],
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    exception = assert_raises(RuntimeError) { balancer.execute }
    assert_match(/score must be between 1 and 999/, exception.message)
  end

  def test_when_customers_input_exceeds_the_count_999999
    balancer = CustomerSuccessBalancing.new(
      build_scores([10, 20]),
      build_scores(Array(1..1_000_000)),
      []
    )
    exception = assert_raises(RuntimeError) { balancer.execute }
    assert_match(/The customers collection exceeds the limit of 999999 customers/, exception.message)
  end

  def test_customer_id_input_min_limit
    balancer = CustomerSuccessBalancing.new(
      build_scores([10, 20]),
      [{ id: 0, score: 2 }],
      []
    )
    exception = assert_raises(RuntimeError) { balancer.execute }
    assert_match(/id must be between 1 and 999999/, exception.message)
  end

  def test_customer_id_input_max_limit
    balancer = CustomerSuccessBalancing.new(
      build_scores([10, 20]),
      [{ id: 1_000_000, score: 2 }],
      []
    )
    exception = assert_raises(RuntimeError) { balancer.execute }
    assert_match(/id must be between 1 and 999999/, exception.message)
  end

  def test_customer_score_input_min_limit
    balancer = CustomerSuccessBalancing.new(
      build_scores([10, 20]),
      [{ id: 1, score: 0 }],
      []
    )
    exception = assert_raises(RuntimeError) { balancer.execute }
    assert_match(/score must be between 1 and 99999/, exception.message)
  end

  def test_customer_score_input_max_limit
    balancer = CustomerSuccessBalancing.new(
      build_scores([10, 20]),
      [{ id: 1, score: 100_000 }],
      []
    )
    exception = assert_raises(RuntimeError) { balancer.execute }
    assert_match(/score must be between 1 and 99999/, exception.message)
  end

  def test_when_absents_exceeds_limit
    balancer = CustomerSuccessBalancing.new(
      build_scores([10, 20, 30, 40]),
      build_scores([10, 20]),
      [1, 2, 3]
    )
    exception = assert_raises(RuntimeError) { balancer.execute }
    assert_match(/The managers absents is more than expected/, exception.message)
  end
end
