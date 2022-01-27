class Job < ApplicationRecord
  belongs_to :employee
  validates_presence_of :duration, :total_pay, :date_completed, :role
  validates_inclusion_of :role, in: Employee.occupations.keys
  validate :date_completed, if: ->{errors.add(:date_completed, 'must enter a date within a month from now') if date_completed and date_completed < 1.month.ago}
  has_one_attached :document
end
