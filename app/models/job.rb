class Job < ApplicationRecord
  belongs_to :employee
  validates_presence_of :total_pay, :role
  validates_inclusion_of :role, in: Employee.occupations.keys
  validate :no_overlap_dates
  has_one_attached :document

  private

  def no_overlap_dates
    unless date_completed.present?
      errors.add(:date_completed, "please include a date completed")
      return
    end

    if date_completed < 1.month.ago
      errors.add(:date_completed, "cannot log a job from more than a month ago")
      return
    end
    
    unless duration.is_a?(Integer) and duration > 0
      errors.add(:duration, "duration needs to be present")
      return
    end
    # if any jobs previous end date is greater than our current start date
    # that doesn't make logical sense
    start_date = date_completed - duration.days
    if Job.where(employee_id: employee_id).any? { |j| j.date_completed > start_date }
      errors.add(:date_completed, "Invalid dates please check: you couldn't have started a job during another active job")
    end
  end
end
