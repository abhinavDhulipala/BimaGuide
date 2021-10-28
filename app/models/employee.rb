class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  @@viable_occupations = %i[porter guide]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates_inclusion_of :occupation, in: @@viable_occupations, on: :create, message: "not part of viable occupation"

  def self.viable_occupations
    @@viable_occupations
  end
end
