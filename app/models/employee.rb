class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  VIABLE_OCCUPATIONS = %i[porter guide]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates_inclusion_of :occupation, in: VIABLE_OCCUPATIONS , on: :create, message: "not part of viable occupation"
  validates_uniqueness_of :email, case_sensitive: false

  def self.viable_occupations
    VIABLE_OCCUPATIONS
  end
end
