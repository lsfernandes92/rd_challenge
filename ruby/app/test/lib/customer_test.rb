# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../src/lib/customer'

class CustomerTest < Minitest::Test
  def setup
    @customer = Customer.new(1, 60)
  end

  def test_when_is_being_creating
    assert_equal 1, @customer.id
    assert_equal 60, @customer.score
  end

  def test__with_validations__on_id_attribute__validates_type
    exception = assert_raises(InvalidCustomerError) { Customer.new('foo', 10) }

    assert_match('Id must be an Integer.', exception.message)
  end

  def test__with_validations__on_id_attribute__validates_min_range
    exception = assert_raises(InvalidCustomerError) { Customer.new(0, 10) }

    assert_match('Id must be between 1 and 999999.', exception.message)
  end

  def test__with_validations__on_id_attribute__validates_max_range
    exception = assert_raises(InvalidCustomerError) { Customer.new(1_000_000, 10) }

    assert_match('Id must be between 1 and 999999.', exception.message)
  end

  def test__with_validations__on_score_attribute__validates_type
    exception = assert_raises(InvalidCustomerError) { Customer.new(0, 'foo') }

    assert_match('Score must be an Integer.', exception.message)
  end

  def test__with_validations__on_score_attribute__validates_min_range
    exception = assert_raises(InvalidCustomerError) { Customer.new(1, 0) }

    assert_match('Score must be between 1 and 99999.', exception.message)
  end

  def test__with_validations__on_score_attribute__validates_max_range
    exception = assert_raises(InvalidCustomerError) { Customer.new(1, 100_000) }

    assert_match('Score must be between 1 and 99999.', exception.message)
  end
end
