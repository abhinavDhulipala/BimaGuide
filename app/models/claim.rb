class Claim < ApplicationRecord
  validate ->{errors.add(:amount, 'cannot claim that much') if Config.max_claim_amount.fetch < self.amount}

  has_many_attached :support

  # make claim; can only have one outstanding claim at a time
  def make

  end

  belongs_to :employee
end
