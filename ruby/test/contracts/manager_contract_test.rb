# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/contracts/manager_contract'

class ManagerContractTests < Minitest::Test
  def test_id_min_limit
    @result = contract.call(ids: [0], scores: [0])
    assert_equal true, @result.failure?
    assert_includes(result_id_errors, ['id must be between 1 and 999'])
  end

  def test_id_max_limit
    @result = contract.call(ids: [1000], scores: [10])
    assert_equal true, @result.failure?
    assert_includes(result_id_errors, ['id must be between 1 and 999'])
  end

  def test_score_min_limit
    @result = contract.call(ids: [1], scores: [0])
    assert_equal true, @result.failure?
    assert_includes(result_scores_errors, ['score must be between 1 and 9999'])
  end

  def test_score_max_limit
    @result = contract.call(ids: [1], scores: [10_000])
    assert_equal true, @result.failure?
    assert_includes(result_scores_errors, ['score must be between 1 and 9999'])
  end

  private

  def contract
    @contract ||= ManagerContract.new
  end

  def result_scores_errors
    @result.errors.to_h[:scores].first
  end

  def result_id_errors
    @result.errors.to_h[:ids].first
  end
end
