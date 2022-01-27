module EmployeesHelper
    
    def default_image
        'https://st3.depositphotos.com/15648834/17930/v/600/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg'
    end 

    def occupation_dropdown 
        Employee::VIABLE_OCCUPATIONS.map {|oc| [oc.humanize, oc]}
    end
end
