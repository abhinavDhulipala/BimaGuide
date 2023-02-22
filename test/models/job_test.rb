# frozen_string_literal: true

require 'test_helper'

class JobTest < ActiveSupport::TestCase
  setup do
    Job.delete_all
    @employee = employees(:default)
  end

  test '#less_than_now date_started & completed in future' do
    job = Job.new(total_pay: 50, role: :cook, date_started: 1.days.since, date_completed: 10.days.since, employee: @employee)
    job.send(:less_than_now)
    assert_equal job.errors.size, 2
    assert job.errors.map{|e| e.attribute}.include?(:date_completed), 'date_completed should be less than present time'
    assert job.errors.map{|e| e.attribute}.include?(:date_started), 'date_started should be less than present time'
  end

  test '#less_than_now date_completed in future' do
    job = Job.new(total_pay: 50, role: :cook, date_started: 1.days.ago, date_completed: 10.days.since, employee: @employee)
    job.send(:less_than_now)
    assert_equal job.errors.size, 1
    assert job.errors.map{|e| e.attribute}.include?(:date_completed), 'date_completed should be less than present time'
  end

  test '#no_overlap_dates job inside other job range' do
    ## Old job
    ##    start[=================================]end
    ## New Job
    ##               start[==========]end
    @employee.jobs.create!(total_pay: 50, role: :cook, date_started: 10.days.ago, date_completed: 1.day.ago)
    job = Job.new(total_pay: 50, role: :cook, date_started: 8.days.ago, date_completed: 3.day.ago, employee: @employee)
    job.send(:no_overlap_dates)
    assert_equal job.errors.size, 1
    assert job.errors.map{|e| e.attribute}.include?(:date_completed), 'date_completed: happened within prior job'
  end

  test '#no_overlap_dates job_completed inside other job range' do
    ## Old job
    ##    start[=================================]end
    ## New Job
    ## start[==========]end
    @employee.jobs.create!(total_pay: 50, role: :cook, date_started: 10.days.ago, date_completed: 1.day.ago)
    job = Job.new(total_pay: 50, role: :cook, date_started: 12.days.ago, date_completed: 3.day.ago, employee: @employee)
    job.send(:no_overlap_dates)
    assert_equal job.errors.size, 1
    assert job.errors.map{|e| e.attribute}.include?(:date_completed), 'date_completed: happened within prior job'
  end

  test '#no_overlap_dates job_started inside other job range' do
    ## Old job
    ##    start[===================]end
    ## New Job
    ##                     start[==========]end
    @employee.jobs.create!(total_pay: 50, role: :cook, date_started: 10.days.ago, date_completed: 2.day.ago)
    job = Job.new(total_pay: 50, role: :cook, date_started: 8.days.ago, date_completed: 1.day.ago, employee: @employee)
    job.send(:no_overlap_dates)
    assert_equal job.errors.size, 1
    assert job.errors.map{|e| e.attribute}.include?(:date_completed), 'date_completed: happened within prior job'
  end
end
