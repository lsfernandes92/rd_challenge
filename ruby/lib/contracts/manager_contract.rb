# frozen_string_literal: true

require 'dry/validation'

class ManagerContract < Dry::Validation::Contract
  params do
    optional(:ids).array(:integer)
    optional(:scores).array(:integer)
  end

  rule(:ids).each { key.failure('id must be between 1 and 999') if id_in_range?(value) }
  rule(:scores).each { key.failure('score must be between 1 and 9999') if score_in_range?(value) }

  private

  def id_in_range?(value)
    (value < 1 || value > 999)
  end

  def score_in_range?(value)
    (value < 1 || value > 9999)
  end
end
