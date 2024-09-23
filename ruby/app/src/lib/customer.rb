# frozen_string_literal: true

require_relative '../validators/customer_validator'

class Customer
  include ActiveModel::Validations

  validates_with CustomerValidator

  attr_reader :id, :score

  def initialize(id, score)
    @id = id
    @score = score
    validate
  end
end
