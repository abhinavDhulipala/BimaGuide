require "test_helper"

class JobTest < ActiveSupport::TestCase

  setup do 
    @employee = employees(:default)
  end

  test 'job validation: job cannot be started while on prior job' do 
      job1 = @employee.jobs.create!(date_completed: 10.days.ago, duration: 5, total_pay: 80, role: 'guide')

      # job starts todays before the end of job 1, should be invalid
      job2 = @employee.jobs.create(date_completed: 5.days.ago, duration: 7, total_pay: 80, role: 'guide')
      refute_predicate job2, :persisted?
      assert_includes job2.errors, :date_completed
      assert_equal job2.errors[:date_completed], ["invalid dates please check: you couldn't have started a job during another active job"]

      job2 = @employee.jobs.create(date_completed: 5.days.ago, duration: 5, total_pay: 80, role: 'guide')
      assert_predicate job2, :persisted?
  end

  test 'job validation: presence' do 
    job1 = @employee.jobs.new( duration: 5, total_pay: 80, role: 'guide')
    refute_predicate job1, :valid?
    job1 = @employee.jobs.new(date_completed: 10.days.ago, total_pay: 80, role: 'guide')
    refute_predicate job1, :valid?
    job1 = @employee.jobs.new(date_completed: 10.days.ago, duration: 5, role: 'guide')
    refute_predicate job1, :valid?
    job1 = @employee.jobs.new(date_completed: 10.days.ago, duration: 5, total_pay: 80)
    refute_predicate job1, :valid?
  end
end
