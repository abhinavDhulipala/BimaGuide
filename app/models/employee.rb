# frozen_string_literal: true

class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  ADDITIONAL_INFO = %w[address1 zip phone].freeze

  has_many :contributions
  has_many :jobs
  has_many :claims
  has_one_attached :avatar
  enum occupation: { 'porter' => 0, 'guide' => 1, 'cook' => 2, 'head_guide' => 3, 'chairman' => 4, 'secretary' => 5, 'spokesman' => 6, 'treasurer' => 7 },
       _default: 'porter'
  enum role: { 'contributor' => 0, 'member' => 1, 'admin' => 2, 'super_admin' => 3 }, _default: 'contributor'
  validates :email, uniqueness: { case_sensitive: false }
  validates :id, uniqueness: { allow_blank: true }
  validates :first_name, :last_name, presence: true
  validates :phone, phone: { message: 'incorrect phone number format. Please include country code
  and phone number exp: +255 750995366', allow_blank: true }
  validates :phone, uniqueness: { message: 'phone number already in use by another user', allow_blank: true }
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  before_create { first_name.downcase! and last_name.downcase! }
  before_update { first_name.downcase! and last_name.downcase! }

  pay_customer
  attr_readonly :email

  attr_accessor :skip_role_validation

  @skip_role_validation = false

  def latest_contribution_date
    contributions.order(:created_at).pluck(:created_at).last or 200.years.ago
  end

  def latest_job_date
    jobs.order(:date_completed).pluck(:date_completed).last or 200.years.ago
  end

  def votable_employees
    # force evaluation for all employees.
    Employee.where('role > ?', Employee.roles[:contributor]).where.not(id: self) || []
  end

  def role
    return self[:role] if @skip_role_validation
    # anyone with privileges admin privileges and above
    return self[:role] if Employee.roles[self[:role]] >= Employee.roles[:admin]

    if jobs.count >= Config.min_jobs.fetch &&
       contributions.count >= Config.min_contributions.fetch &&
       latest_contribution_date >= Config.latest_contribution.fetch.ago &&
       latest_job_date >= Config.latest_job.fetch.ago

      update(role: 'member')
      return 'member'
    end
    update(role: 'contributor')
    'contributor'
  end

  def unintialized_attrs
    # address2 not included as it is not always required
    attributes.select { |k, v| v.nil? and Employee::ADDITIONAL_INFO.include? k }.keys
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
