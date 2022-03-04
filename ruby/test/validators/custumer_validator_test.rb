# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/validators/customer_validator'
require_relative '../../helpers/score_build_helper'

class CustomerValidatorTests < Minitest::Test
  include ScoreBuildHelper

  def test_when_collection_exceeds_the_count_999999
    validator = CustomerValidator.new(sort_by_score(build_scores(Array(1..1000000))))
    exception = assert_raises(RuntimeError) { validator.validate }
    assert_match /The customers collection exceeds the limit of 999999 customers/, exception.message
  end

  def test_id_min_limit
    validator = CustomerValidator.new({"0" => 1})
    exception = assert_raises(RuntimeError) { validator.validate }
    assert_match /id must be between 1 and 999999/, exception.message
  end

  def test_id_max_limit
    validator = CustomerValidator.new({"1000000" => 1})
    exception = assert_raises(RuntimeError) { validator.validate }
    assert_match /id must be between 1 and 999999/, exception.message
  end

  def test_score_min_limit
    validator = CustomerValidator.new({"1" => 0})
    exception = assert_raises(RuntimeError) { validator.validate }
    assert_match /score must be between 1 and 99999/, exception.message
  end

  def test_score_max_limit
    validator = CustomerValidator.new({"1" => 100000})
    exception = assert_raises(RuntimeError) { validator.validate }
    assert_match /score must be between 1 and 99999/, exception.message
  end
end
