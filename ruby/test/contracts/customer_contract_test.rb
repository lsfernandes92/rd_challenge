# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/contracts/customer_contract'

class CustomerContractTests < Minitest::Test
  def test_id_min_limit
    @result = contract.call(ids: [0], scores: [0])
    assert_equal true, @result.failure?
    assert_includes(result_id_errors, ['id must be between 1 and 999999'])
  end

  def test_id_max_limit
    @result = contract.call(ids: [1_000_000], scores: [10])
    assert_equal true, @result.failure?
    assert_includes(result_id_errors, ['id must be between 1 and 999999'])
  end

  def test_score_min_limit
    @result = contract.call(ids: [1], scores: [0])
    assert_equal true, @result.failure?
    assert_includes(result_scores_errors, ['score must be between 1 and 99999'])
  end

  def test_score_max_limit
    @result = contract.call(ids: [1], scores: [100_000])
    assert_equal true, @result.failure?
    assert_includes(result_scores_errors, ['score must be between 1 and 99999'])
  end

  private

  def contract
    @contract ||= CustomerContract.new
  end

  def result_scores_errors
    @result.errors.to_h[:scores].first
  end

  def result_id_errors
    @result.errors.to_h[:ids].first
  end
end
