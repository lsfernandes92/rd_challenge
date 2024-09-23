# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../src/lib/process_managers_attendance'

class ProcessManagersAttendanceTest < Minitest::Test
  include ScoresBuildHelper
  include SetCustomersHelper
  include SetManagersHelper

  def setup
    @subject = ProcessManagersAttendance.new(
      set_managers(build_scores([10, 20])),
      set_customers(build_scores([10, 20]))
    )
  end

  def test_when_is_being_creating
    assert_equal Array, @subject.managers.class
    assert_equal Manager, @subject.managers.first.class
    assert_equal Array, @subject.customers.class
    assert_equal Customer, @subject.customers.first.class
  end

  def test_assign_customers_to_managers
    subject = ProcessManagersAttendance.new(
      set_managers(build_scores([20, 30])),
      set_customers(build_scores([10, 20]))
    )

    result = subject.process_managers_attendance

    assert_equal [1, 2], result.first.customers_attended_id
    assert_equal [], result.last.customers_attended_id
  end

  def test__when_has_no_manager__returns_empty_array
    subject = ProcessManagersAttendance.new(
      [],
      set_customers(build_scores([10, 20]))
    )

    result = subject.process_managers_attendance

    assert_equal [], result
  end

  def test__when_has_no_customer__returns_managers_without_customers_attended
    subject = ProcessManagersAttendance.new(
      set_managers(build_scores([20, 30])),
      []
    )

    result = subject.process_managers_attendance

    assert_equal [], result.first.customers_attended_id
    assert_equal [], result.last.customers_attended_id
  end

  def test__when_has_no_customer_to_attend__returns_managers_without_customers_attended
    subject = ProcessManagersAttendance.new(
      set_managers(build_scores([20, 30])),
      set_customers(build_scores([40, 50]))
    )

    result = subject.process_managers_attendance

    assert_equal [], result.first.customers_attended_id
    assert_equal [], result.last.customers_attended_id
  end
end
