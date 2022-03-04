require 'dry/validation'

class ManagerContract < Dry::Validation::Contract
  params do
    required(:id).filled(:integer)
    required(:score).filled(:integer)
  end

  rule(:id) { key.failure('id must be between 1 and 999') if value < 1 }
  rule(:id) { key.failure('id must be between 1 and 999') if value > 999 }
  rule(:score) { key.failure('score must be between 1 and 9999') if value < 1 }
  rule(:score) { key.failure('score must be between 1 and 9999') if value > 9999 }
end
