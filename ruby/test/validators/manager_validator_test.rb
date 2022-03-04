# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/validators/manager_validator'
require_relative '../../helpers/score_build_helper'

class ManagerValidatorTests < Minitest::Test
  include ScoreBuildHelper

  def test_duplicate_level
    validator = ManagerValidator.new({"1": 10, "2": 10})
    exception = assert_raises(RuntimeError) { validator.validate }
    assert_match /It must not have managers with the same level!/, exception.message
  end

  def test_when_collection_exceeds_the_count_999
    validator = ManagerValidator.new(sort_by_score(build_scores(Array(1..1000))))
    exception = assert_raises(RuntimeError) { validator.validate }
    assert_match /The managers collection exceeds the limit of 999 managers/, exception.message
  end

  def test_id_min_limit
    validator = ManagerValidator.new({"0" => 1})
    exception = assert_raises(RuntimeError) { validator.validate }
    assert_match /id must be between 1 and 999/, exception.message
  end

  def test_id_max_limit
    validator = ManagerValidator.new({"1000" => 1})
    exception = assert_raises(RuntimeError) { validator.validate }
    assert_match /id must be between 1 and 999/, exception.message
  end

  def test_score_min_limit
    validator = ManagerValidator.new({"1" => 0})
    exception = assert_raises(RuntimeError) { validator.validate }
    assert_match /score must be between 1 and 999/, exception.message
  end

  def test_score_max_limit
    validator = ManagerValidator.new({"1" => 10000})
    exception = assert_raises(RuntimeError) { validator.validate }
    assert_match /score must be between 1 and 999/, exception.message
  end
end
