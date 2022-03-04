# frozen_string_literal: true

require 'dry/validation'

class CustomerContract < Dry::Validation::Contract
  params do
    optional(:ids).array(:integer)
    optional(:scores).array(:integer)
  end

  rule(:ids).each { key.failure('id must be between 1 and 999999') if id_in_range?(value) }
  rule(:scores).each { key.failure('score must be between 1 and 99999') if score_in_range?(value) }

  private

  def id_in_range?(value)
    (value < 1 || value > 999_999)
  end

  def score_in_range?(value)
    (value < 1 || value > 99_999)
  end
end
