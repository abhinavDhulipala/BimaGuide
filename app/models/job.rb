# frozen_string_literal: true

class Job < ApplicationRecord
  belongs_to :employee
  validates :total_pay, :role, :date_completed, presence: true
  validates :id, uniqueness: true
  validates :role, inclusion: { in: Employee.occupations.keys }
  validate :no_overlap_dates
  validate :less_than_now
  before_destroy -> { errors.add(:date_created, 'cannot delete a 1 week old record') if created_at < 1.week.ago }
  has_one_attached :document

  private

  def less_than_now
    errors.add(:date_completed, "can't log jobs in the future") if date_completed > DateTime.now
    errors.add(:date_started, "can't log jobs in the future") if date_started > DateTime.now
  end
    
  def no_overlap_dates
    return errors.add(:date_completed, 'must be included') if date_completed.blank?
    return errors.add(:date_started, 'must be included ') if date_started.blank?
    return errors.add(:date_completed, 'date completed must be ahead of date started') if date_started >= date_completed

    if date_completed < Config.job_log_limit.fetch.ago
      return errors.add(:date_completed,
                        'cannot log a job from more than a month ago')
    end

    # check that date ranges don't overlap
    if Employee.find(employee_id).jobs.where.not(id: id).any? do |dc|
         [dc.date_started, date_started].max < [dc.date_completed, date_completed].min
       end
      errors.add(:date_completed,
                 "Invalid dates please check: you couldn't have started a job during another active job")
    end
  end
end
