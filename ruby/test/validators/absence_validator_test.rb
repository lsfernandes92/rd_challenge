# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/validators/absence_validator'
require_relative '../../helpers/score_build_helper'

class AbsenceValidatorTests < Minitest::Test
  include ScoreBuildHelper

  def test_when_absent_managers_is_empty
    validator = AbsenceValidator.new(
      [10, 20],
      []
    )
    assert validator.validate, true
  end

  def test_with_reasonable_absents
    validator = AbsenceValidator.new(
      [10, 20, 30, 40],
      [1, 2]
    )
    assert validator.validate, true
  end

  def test_when_absents_exceeds_limit
    validator = AbsenceValidator.new(
      [10, 20, 30, 40],
      [1, 2, 3]
    )
    exception = assert_raises(RuntimeError) { validator.validate }
    assert_match(/The managers absents is more than expected/, exception.message)
  end
end
