class Job < ApplicationRecord
  belongs_to :employee
  validates_presence_of :duration, :total_pay, :date_completed, :role
  validates_inclusion_of :role, in: Employee.occupations.keys
  validate :date_completed, if: ->{errors.add(:date_completed, 'must enter a date within a month from now') if date_completed.present? and date_completed < 1.month.ago}
  validate :no_overlap_dates
  has_one_attached :document

  private

  def no_overlap_dates
    # if any jobs previous end date is greater than our current start date
    # that doesn't make logical sense
    start_date = date_completed - duration.days
    if Job.where(employee_id: employee_id).any? { |j| j.date_completed > start_date }
      errors.add(:date_completed, "Invalid dates please check: you couldn't have started a job during another active job")
    end
  end
end
