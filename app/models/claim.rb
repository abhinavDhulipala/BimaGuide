# frozen_string_literal: true

class Claim < ApplicationRecord
  validate -> { errors.add(:amount, 'cannot claim that much') if Config.max_claim_amount.fetch < amount }

  belongs_to :employee
  has_many_attached :support

  # make claim; can only have one outstanding claim at a time
  def make; end
end
