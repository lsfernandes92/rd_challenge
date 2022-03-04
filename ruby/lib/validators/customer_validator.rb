require_relative '../contracts/customer_contract'

class CustomerValidator
  def initialize(customers)
    @customers = customers
  end

  def validate
    validates_exceeds_collection_count
    validates_ids_and_scores
  end

  private

  def validates_exceeds_collection_count
    raise 'The customers collection exceeds the limit of 999999 customers' if exceeds_collection_count?
  end

  def exceeds_collection_count?
    @customers.count > 999999
  end

  def validates_ids_and_scores
    ids = @customers.keys
    scores = @customers.values
    result = contract.(ids: ids, scores: scores)
    raise "The customers collection fail with the following: #{result.errors.to_h}" if result.failure?
  end

  def contract
    @contract ||= CustomerContract.new
  end
end
