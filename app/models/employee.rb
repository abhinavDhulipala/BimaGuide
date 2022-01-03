class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  VIABLE_OCCUPATIONS = %w[porter guide]

  validates_inclusion_of :occupation, in: VIABLE_OCCUPATIONS , on: :create, message: "#{@occupation} not part of viable occupation"
  validates_uniqueness_of :email, case_sensitive: false
  validates_presence_of :first_name, :last_name
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  def self.viable_occupations
    VIABLE_OCCUPATIONS
  end
end
