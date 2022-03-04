# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/contracts/manager_contract'

class ManagerContractTests < Minitest::Test

  def test_id_min_limit
    result = contract.(id: '0', score: '10')
    assert_equal true, result.failure?
    assert_match /id must be between 1 and 999/, result.errors.to_h[:id].first
  end

  def test_id_max_limit
    result = contract.(id: '1000', score: '10')
    assert_equal true, result.failure?
    assert_match /id must be between 1 and 999/, result.errors.to_h[:id].first
  end

  def test_score_min_limit
    result = contract.(id: '1', score: '0')
    assert_equal true, result.failure?
    assert_match /score must be between 1 and 999/, result.errors.to_h[:score].first
  end

  def test_score_max_limit
    result = contract.(id: '1', score: '10000')
    assert_equal true, result.failure?
    assert_match /score must be between 1 and 999/, result.errors.to_h[:score].first
  end

  private

  def contract
    @contract ||= ManagerContract.new
  end
end
