class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  VIABLE_OCCUPATIONS = %w[porter guide cook head_guide]
  ADDITIONAL_INFO = %w[address1 zip phone]
  ROLES = %w[contributor member admin]

  has_many :contributions
  has_many :jobs
  has_one_attached :avatar
  validates_inclusion_of :occupation, in: VIABLE_OCCUPATIONS , message: "%{value} not part of viable occupation"
  validates_inclusion_of :role, in: ROLES, default: 'contributor', message: "%{value} not a viable role"
  validates_uniqueness_of :email, case_sensitive: false
  validates_presence_of :first_name, :last_name
  validates :phone, phone: {message: 'incorrect phone number format. Please include country code 
  and phone number exp: +255 750995366', allow_blank: true}
  validates_uniqueness_of :phone, message: 'phone number already in use by another user', allow_blank: true
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  before_save {first_name.downcase!}
  before_save {last_name.downcase!}

  def latest_contribution_date
    contributions.order(:created_at).pluck(:created_at).last
  end

  def view_all_employees filters, orders
      
  end

  def unintialized_attrs 
    # address2 not included as it is not always required
    attributes.select {|k, v| v.nil? and Employee::ADDITIONAL_INFO.include? k}.keys
  end

  private

  def is_privledged?
    role != 'contributor'
  end
  
end
