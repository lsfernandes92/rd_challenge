# frozen_string_literal: true

require 'minitest/autorun'
require 'byebug'
require_relative '../lib/manager'
require_relative '../helpers/score_build_helper'

class ManagerTests < Minitest::Test
  include ScoreBuildHelper

  def setup
    super
    @manager = Manager.new(1, 60)
  end

  def test_when_is_being_creating
    assert_equal 1, @manager.id
    assert_equal 60, @manager.score
    assert_equal 0, @manager.customers_count
  end

  def test_manager_should_attend_only_customers_within_his_score
    assert_equal [2, 4, 5, 6], @manager.attend_customers(customers).sort
    assert_equal 4, @manager.customers_count
  end

  def test_when_manager_has_no_customers_to_attend
    customers = sort_by_score(build_scores([61, 70, 100]))

    assert_equal [], @manager.attend_customers(customers)
    assert_equal 0, @manager.customers_count
  end

  private

  def customers
    customers = sort_by_score(build_scores([90, 20, 70, 40, 60, 10]))
  end
end
