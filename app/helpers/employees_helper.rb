module EmployeesHelper
    
    def default_image
        'https://st3.depositphotos.com/15648834/17930/v/600/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg'
    end

    def all_occupations
      Employee.occupations.keys
    end

    def occupation_dropdown 
     all_occupations.map {|e| [e.humanize, e]}
    end

    def view_contribution contribution
      return 'no contributions made' if contribution < 199.years.ago
      Time.at(contribution).strftime('%b%e, %C at %k:%M %p')
    end
end
