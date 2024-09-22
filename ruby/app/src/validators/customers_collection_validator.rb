require 'active_model'

class CustomersCollectionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    @record = record
    
    validates_exceeds_collection_count
  end

  private

  def validates_exceeds_collection_count
    if exceeds_collection_count?
      raise(InvalidCustomersCollectionError, 'The customers collection exceeds the limit of 999999 customers.')
    end
  end
  def exceeds_collection_count? = @record.customers.count > 999_999
end

class InvalidCustomersCollectionError < StandardError; end