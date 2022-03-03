# frozen_string_literal: true

require 'minitest/autorun'
require 'byebug'
require_relative '../lib/rate_managers'
require_relative '../lib/manager'
require_relative '../helpers/score_build_helper'

class RateManagersTests < Minitest::Test
  include ScoreBuildHelper

  def setup
    super
    @manager_list = []
    @manager_list << Manager.new(1, 20)
    @rate_managers = RateManagers.new(@manager_list)
  end

  def test_when_is_being_creating
    assert_equal 1, @rate_managers.managers.count
  end

  def test_managers_should_be_sorted_by_clients
    manager_with_most_clients = Manager.new(3, 60)
    manager_with_most_clients.attend_customers(customers)
    @manager_list << manager_with_most_clients
    rate_managers = RateManagers.new(@manager_list)

    assert_equal 3, rate_managers.managers.first.id
  end

  def test_when_has_no_manager_most_rated_should_be_0
    rate_managers = RateManagers.new([])

    assert_equal 0, rate_managers.most_rated
  end

  def test_when_has_one_manager_most_rated_should_be_itself
    only_manager = Manager.new(3, 60)
    rate_managers = RateManagers.new([only_manager])

    assert_equal 3, rate_managers.most_rated
  end

  def test_when_two_managers_has_the_same_customers_count
    foo_manager = Manager.new(1, 60)
    bar_manager = Manager.new(2, 60)
    rate_managers = RateManagers.new([foo_manager, bar_manager])

    assert_equal 0, rate_managers.most_rated
  end

  def test_when_two_managers_has_different_customers_count
    foo_manager = Manager.new(1, 60)
    bar_manager = Manager.new(2, 60)
    bar_manager.attend_customers(customers)
    rate_managers = RateManagers.new([foo_manager, bar_manager])

    assert_equal 2, rate_managers.most_rated
  end

  private

  def customers
    customers = sort_by_score(build_scores([90, 20, 70, 40, 60, 10]))
  end
end
