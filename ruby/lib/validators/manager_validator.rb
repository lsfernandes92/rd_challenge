require_relative '../manager'
require_relative '../contracts/manager_contract'

class ManagerValidator
  def initialize(managers)
    @managers = managers
  end

  def validate
    validates_duplicate_score
    validates_exceeds_collection_count
    validates_id_and_score
  end

  private

  def validates_duplicate_score
    raise 'It must not have managers with the same level!' if has_duplicate_score?
  end

  def has_duplicate_score?
    @managers.values.uniq != @managers.values
  end

  def validates_exceeds_collection_count
    raise 'The managers collection exceeds the limit of 999 managers' if exceeds_collection_count?
  end

  def exceeds_collection_count?
    @managers.count > 999
  end

  def validates_id_and_score
    @managers.each do |manager_id, manager_score|
      result = contract.(id: manager_id, score: manager_score)
      raise "The managers collection fail with the following: #{result.errors.to_h}" if result.failure?
    end
  end

  def contract
    @contract ||= ManagerContract.new
  end
end
