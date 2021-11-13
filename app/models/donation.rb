class Donation < ApplicationRecord
  
  attr_reader :price
  def initialize donation_amount
    @price = donation_amount
  end
end
