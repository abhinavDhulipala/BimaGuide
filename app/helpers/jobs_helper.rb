module JobsHelper
 def job_form_url job
   unless job
     employee_jobs_path current_employee
   else
     employee_job_path current_employee, job
   end
 end
end
