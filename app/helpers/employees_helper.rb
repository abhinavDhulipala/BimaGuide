module EmployeesHelper
    
    def default_image
        'https://st3.depositphotos.com/15648834/17930/v/600/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg'
    end

    def all_occupations
      Employee.occupations.keys
    end

    def profile_pic(employee)
      employee.avatar.attached? ? employee.avatar : default_image
    end

    def submit_text(edit_enabled)
      edit_enabled ? 'Edit' : 'Edit Profile'
    end
    def occupation_dropdown 
     all_occupations.map {|e| [e.humanize, e]}
    end

    def view_contribution(contribution_date)
      # contributions are default set
      return 'no contributions made' if contribution_date < 199.years.ago
      display_time(contribution_date)
    end
end
