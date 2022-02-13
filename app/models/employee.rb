class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  ADDITIONAL_INFO = %w[address1 zip phone]

  has_many :contributions
  has_many :jobs
  has_one_attached :avatar
  enum occupation: %w[porter guide cook head_guide], _default: 'porter'
  enum role: %w[contributor member admin super_admin], _default: 'contributor'
  validates_uniqueness_of :email, case_sensitive: false
  validates_uniqueness_of :id, allow_blank: true
  validates_presence_of :first_name, :last_name
  validates :phone, phone: {message: 'incorrect phone number format. Please include country code 
  and phone number exp: +255 750995366', allow_blank: true}
  validates_uniqueness_of :phone, message: 'phone number already in use by another user', allow_blank: true
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  before_save {first_name.downcase!}
  before_save {last_name.downcase!}

  pay_customer

  def latest_contribution_date
    contributions.order(:created_at).pluck(:created_at).last or 200.years.ago
  end

  def latest_job_date
    jobs.order(:date_completed).pluck(:date_completed).last or 200.years.ago
  end

  def role
    # anyone with privileges admin privileges and above
    return self[:role] if Employee.roles[self[:role]] >= Employee.roles[:admin]
    if jobs.count >= Config.min_jobs.fetch and
      contributions.count >= Config.min_contributions.fetch and
      latest_contribution_date >= Config.latest_contribution.fetch.ago and
      latest_job_date >= Config.latest_job.fetch.ago
      update(role: 'member')
      return 'member'
    end
    update(role: 'contributor')
    'contributor'
  end

  def unintialized_attrs 
    # address2 not included as it is not always required
    attributes.select {|k, v| v.nil? and Employee::ADDITIONAL_INFO.include? k}.keys
  end

  # for pay compatibility
  def name
    "#{first_name.humanize} #{last_name.humanize}"
  end

  def pay_customer_name
    name
  end

  def privileged?
    Employee.roles[role] >= Employee.roles['member']
  end
  
end
