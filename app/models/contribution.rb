class Contribution < ApplicationRecord
    belongs_to :employee
    validates_numericality_of :amount, less_than: Config.max_contribution_amount.fetch, 
        message: "can only input a number less than #{Config.max_contribution_amount.fetch}. inputed %{value}"
    validate :no_recent_contribution
    validate :max_contrib_amount
    validates_uniqueness_of :id

    private

    def no_recent_contribution
      
      limit = Config.max_contribution_frequency.fetch.ago
      curr_date = Employee.find(employee_id).latest_contribution_date
      if curr_date > limit
        errors.add :created_at, "can contribute again in #{Time.at(curr_date - limit).strftime("%d days %H:%M:%S")}"
      end
    end

    def max_contrib_amount
      max_amount = Config.max_contribution_amount.fetch
      if (amount or Float::INFINITY) > max_amount
        errors.add :amount, "can only contribute a max of $#{max_amount}"
      end
    end
end
