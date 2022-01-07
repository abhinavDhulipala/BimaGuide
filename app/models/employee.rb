class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  VIABLE_OCCUPATIONS = %w[porter guide]

  has_many :contributions
  validates_inclusion_of :occupation, in: VIABLE_OCCUPATIONS , on: :create, message: " %{value} not part of viable occupation"
  validates_uniqueness_of :email, case_sensitive: false
  validates_presence_of :first_name, :last_name
  validates :phone, phone: {message: 'incorrect phone number format', allow_blank: true}
  validates_uniqueness_of :phone, message: 'phone number already in use by another user', allow_blank: true
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  def self.viable_occupations
    VIABLE_OCCUPATIONS
  end
  
  def latest_contribution_date
    contributions.order(:created_at).pluck(:created_at).last
  end
end
