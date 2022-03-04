class AbsenceValidator
  def initialize(managers, absent_managers)
    @managers = managers
    @absent_managers = absent_managers
  end

  def validate
    validate_absents
    true
  end

  private

  def validate_absents
    raise 'The managers absents is more than expected' if absence_limit?
  end

  def absence_limit?
    (@absent_managers.count > (@managers.count / 2))
  end
end
