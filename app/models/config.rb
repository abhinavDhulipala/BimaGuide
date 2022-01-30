class Config < ApplicationRecord
  
  # Time units x -> x.month(s).ago, unless otherwise specified
  # How many months since the last job, to be considered active. 
  LATEST_JOB = 12
  MIN_JOBS = 4
  MIN_CONTRIBUTIONS = 19
  LATEST_CONTIRBUTION = 4
  
  # rate limit on contributions 
  MAX_CONTRIBUTION_AMOUNT = 40
  # ~weekly
  MAX_CONTRIBUTION_FREQUENCY = 1


  # Singleton for global configs
  validate ->{errors.add(:base, 'record already exists') if Config.count > 0}, on: :create
  validates_numericality_of :min_contributions, 
    :min_jobs, 
    :latest_job, 
    :latest_contribution, 
    :max_contribution_amount,
    :max_contribution_freq,
    only_integer: true, min: 0

  # Override class single access
  def self.take 
  
    return create(min_jobs: MIN_JOBS, 
      latest_job: LATEST_CONTIRBUTION,
      latest_contribution: LATEST_CONTIRBUTION, 
      min_contributions: MIN_CONTRIBUTIONS,
      max_contribution_amount: MAX_CONTRIBUTION_AMOUNT,
      max_contribution_freq: MAX_CONTRIBUTION_FREQUENCY) unless exists?
    super
  end

  def self.first 
    take
  end

  def self.last
    take
  end
end
