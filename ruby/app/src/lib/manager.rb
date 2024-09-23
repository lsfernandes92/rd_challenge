# frozen_string_literal: true

require_relative '../validators/manager_validator'

class Manager
  include ActiveModel::Validations

  validates_with ManagerValidator

  attr_reader :id, :score, :customers_attended_id

  def initialize(id, score)
    @id = id
    @score = score
    @customers_attended_id = []
    validate
  end

  def attend_customers(customers)
    customers.each do |customer|
      @customers_attended_id << customer.id if attend_customer?(customer.score)
    end

    @customers_attended_id
  end

  private

  def attend_customer?(customer_score) = @score >= customer_score
end
