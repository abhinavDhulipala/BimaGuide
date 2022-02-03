include EmployeesHelper

module JobsHelper
 def job_form_url job
   if job.new_record?
     employee_jobs_path current_employee
   else
     employee_job_path current_employee, job
   end
 end

 def job_duration job
    (job.date_completed.to_date - job.date_started.to_date).to_i
 end
end
