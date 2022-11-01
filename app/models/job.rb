class Job < ApplicationRecord
  belongs_to :employee
  validates_presence_of :total_pay, :role, :date_completed
  validates_uniqueness_of :id
  validates_inclusion_of :role, in: Employee.occupations.keys
  validate :no_overlap_dates
  before_destroy ->{errors.add(:date_created, 'cannot delete a 1 week old record') if created_at < 1.week.ago}
  has_one_attached :document

  private

  def no_overlap_dates
    return errors.add(:date_completed, 'must be included') unless date_completed.present?
    return errors.add(:date_started, 'must be included ') unless date_started.present?
    return errors.add(:date_completed, 'date completed must be ahead of date started') if date_started >= date_completed
    return errors.add(:date_completed, "cannot log a job from more than a month ago") if date_completed < Config.job_log_limit.fetch.ago
    # check that date ranges don't overlap
    if Employee.find(employee_id).jobs.where.not(id: id).any? {|dc| [dc.date_started, date_started].max < [dc.date_completed, date_completed].min}
      errors.add(:date_completed, "Invalid dates please check: you couldn't have started a job during another active job")
    end
  end
end
