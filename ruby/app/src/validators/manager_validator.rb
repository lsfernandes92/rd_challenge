# frozen_string_literal: true

require 'active_model'

class ManagerValidator < ActiveModel::Validator
  def validate(record)
    @record = record

    validate_id_type
    validate_score_type
    validate_id_in_range
    validate_score_in_range
  end

  private

  def validate_id_type
    return if @record.id.is_a?(Integer)

    raise(InvalidManagerError, 'Id must be an Integer.')
  end

  def validate_score_type
    return if @record.score.is_a?(Integer)

    raise(InvalidManagerError, 'Score must be an Integer.')
  end

  def validate_id_in_range
    return if id_in_range?(@record.id)

    raise(InvalidManagerError, 'Id must be between 1 and 999.')
  end

  def id_in_range?(value) = (1..999).cover?(value)

  def validate_score_in_range
    return if score_in_range?(@record.score)

    raise(InvalidManagerError, 'Score must be between 1 and 9999.')
  end

  def score_in_range?(value) = (1..9999).cover?(value)
end

class InvalidManagerError < StandardError; end
