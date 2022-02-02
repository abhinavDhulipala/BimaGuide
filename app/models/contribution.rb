class Contribution < ApplicationRecord
    belongs_to :employee
    validates_numericality_of :amount, less_than: Config.max_contribution_amount, 
        message: "can only input a number less than #{Config.max_contribution_amount}. inputed %{value}"
    validate :no_recent_contribution
    validate :max_contrib_amount
    validates_uniqueness_of :id

    private

    def no_recent_contribution
      
      limit = Config.max_contribution_freq.ago
      curr_date = Employee.find(employee_id).latest_contribution_date || 200.years.ago
      if curr_date > limit
        errors.add :created_at, "can contribute again in #{Time.at(curr_date - limit).strftime("%d days %H:%M:%S")}"
      end
    end

    def max_contrib_amount
      config = Config.take
      if (amount or Float::INFINITY) > config.max_contribution_amount
        errors.add :amount, "can only contribute a max of $#{config.max_contribution_amount}"
      end
    end
end
