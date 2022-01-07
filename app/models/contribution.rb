class Contribution < ApplicationRecord

    MAX_DONATION_AMOUNT = 4

    belongs_to :employee
    validates_numericality_of :amount, less_than: MAX_DONATION_AMOUNT, 
        message: "can only input a number less than #{MAX_DONATION_AMOUNT}. inputed %{value}"
end
