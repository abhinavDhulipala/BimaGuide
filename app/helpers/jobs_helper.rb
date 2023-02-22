# frozen_string_literal: true

module JobsHelper
  include EmployeesHelper
  def job_form_url(job)
    if job.new_record?
      employee_jobs_path current_employee
    else
      employee_job_path current_employee, job
    end
  end
end
