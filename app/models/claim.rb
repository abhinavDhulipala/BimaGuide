class Claim < ApplicationRecord
  validate ->{errors.add(:amount, 'cannot claim that much') if Config.max_claim_amount.fetch < self.amount}

  belongs_to :employee
end
