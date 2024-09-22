require 'active_model'

class AbsenceManagersValidator < ActiveModel::Validator
  def validate(record)
    @record = record

    validate_absents
  end

  private

  def validate_absents
    if absence_limit?
      raise(InvalidAbsenceManagersError, 'The managers absents is more than expected.')
    end
  end
  def absence_limit? = (@record.absent_managers.count > (@record.managers.count / 2))
end

class InvalidAbsenceManagersError < StandardError; end