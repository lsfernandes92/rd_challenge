require_relative '../test_helper'
require_relative '../../src/lib/manager'

class ManagerTest < Minitest::Test
  include ScoresBuildHelper
  include Sortable

  def setup
    @manager = Manager.new(1, 60)
  end

  def test_when_is_being_creating
    assert_equal 1, @manager.id
    assert_equal 60, @manager.score
    assert_equal [], @manager.customers_attended
  end

  def test__with_validations__on_id_attribute__validates_type
    assert_raises(InvalidManagerError) do
      Manager.new('foo', 10)
      raise InvalidManagerError, 'Id must be an Integer.'
    end
  end

  def test__with_validations__on_id_attribute__validates_range
    assert_raises(InvalidManagerError) do
      Manager.new(0, 10)
      raise InvalidManagerError, 'Id must be between 1 and 999.'
    end
  end

  def test__with_validations__on_score_attribute__validates_type
    assert_raises(InvalidManagerError) do
      Manager.new(1, 'foo')
      raise InvalidManagerError, 'Score must be an Integer.'
    end
  end

  def test__with_validations__on_score_attribute__validates_range
    assert_raises(InvalidManagerError) do
      Manager.new(1, 0)
      raise InvalidManagerError, 'Score must be between 1 and 999.'
    end
  end

  def test_manager_should_attend_only_customers_within_his_score
    customers = sort_by_score(build_scores([90, 20, 70, 40, 60, 10]))

    @manager.attend_customers(customers)

    assert_equal [2, 4, 5, 6], @manager.customers_attended.sort
    assert_equal 4, @manager.customers_attended.count
  end

  def test__when_manager_has_no_customers_to_attend__returns_empty_customers_attended
    customers = sort_by_score(build_scores([61, 70, 100]))

    @manager.attend_customers(customers)

    assert_equal [], @manager.customers_attended
    assert_equal 0, @manager.customers_attended.count
  end

  def test__when_passing_an_empty_array_of_customers__returns_empty_customers_attended
    customers = build_scores([])

    @manager.attend_customers(customers)

    assert_equal [], @manager.customers_attended
    assert_equal 0, @manager.customers_attended.count
  end
end