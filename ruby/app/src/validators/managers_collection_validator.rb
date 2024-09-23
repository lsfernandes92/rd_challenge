# frozen_string_literal: true

require 'active_model'

class ManagersCollectionValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, _value)
    @record = record

    validates_duplicate_score
    validates_exceeds_collection_count
  end

  private

  def validates_duplicate_score
    return unless has_duplicate_score?

    raise(InvalidManagersCollectionError, 'Managers cannot have the same level.')
  end
  def has_duplicate_score? = @record.managers.map(&:score).uniq != @record.managers.map(&:score)

  def validates_exceeds_collection_count
    return unless exceeds_collection_count?

    raise(InvalidManagersCollectionError, 'The managers collection exceeds the maximum limit of 999 managers.')
  end
  def exceeds_collection_count? = @record.managers.count > 999
end

class InvalidManagersCollectionError < StandardError; end
