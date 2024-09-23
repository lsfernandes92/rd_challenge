require_relative '../test_helper'
require_relative '../../src/lib/manager'
require_relative '../../src/lib/customer'

class ManagerTest < Minitest::Test
  include ScoresBuildHelper
  include SetCustomersHelper
  include Sortable

  def setup
    @manager = Manager.new(1, 60)
  end

  def test_when_is_being_creating
    assert_equal 1, @manager.id
    assert_equal 60, @manager.score
    assert_equal [], @manager.customers_attended_id
  end

  def test__with_validations__on_id_attribute__validates_type
    exception = assert_raises(InvalidManagerError) { Manager.new('foo', 10) }
    
    assert_match('Id must be an Integer.', exception.message)
  end

  def test__with_validations__on_id_attribute__validates_min_range
    exception = assert_raises(InvalidManagerError) { Manager.new(0, 10) }
    
    assert_match('Id must be between 1 and 999.', exception.message)
  end

  def test__with_validations__on_id_attribute__validates_max_range
    exception = assert_raises(InvalidManagerError) { Manager.new(1000, 10) }
    
    assert_match('Id must be between 1 and 999.', exception.message)
  end

  def test__with_validations__on_score_attribute__validates_type
    exception = assert_raises(InvalidManagerError) { Manager.new(0, 'foo') }
    
    assert_match('Score must be an Integer.', exception.message)
  end

  def test__with_validations__on_score_attribute__validates_min_range
    exception = assert_raises(InvalidManagerError) { Manager.new(1, 0) }
    
    assert_match('Score must be between 1 and 9999.', exception.message)
  end

  def test__with_validations__on_score_attribute__validates_max_range
    exception = assert_raises(InvalidManagerError) { Manager.new(1, 10000) }
    
    assert_match('Score must be between 1 and 9999.', exception.message)
  end

  def test_manager_should_attend_only_customers_within_his_score
    customers = set_customers(build_scores([90, 20, 70, 40, 60, 10]))

    @manager.attend_customers(customers)

    assert_equal [2, 4, 5, 6], @manager.customers_attended_id.sort
    assert_equal 4, @manager.customers_attended_id.count
  end

  def test__when_manager_has_no_customers_to_attend__returns_empty_customers_attended_id
    customers = set_customers(build_scores([61, 70, 100]))

    @manager.attend_customers(customers)

    assert_equal [], @manager.customers_attended_id
    assert_equal 0, @manager.customers_attended_id.count
  end

  def test__when_passing_an_empty_array_of_customers__returns_empty_customers_attended_id
    customers = set_customers(build_scores([]))

    @manager.attend_customers(customers)

    assert_equal [], @manager.customers_attended_id
    assert_equal 0, @manager.customers_attended_id.count
  end
end