class Config < ApplicationRecord
  
  # Time units x -> x.month(s).ago, unless otherwise specified
  # How many months since the last job, to be considered active. 
  LATEST_JOB = 12
  MIN_JOBS = 4
  MIN_CONTRIBUTIONS = 19
  LATEST_CONTRIBUTION = 4
  
  # Maximum USD value of a single contribution
  MAX_CONTRIBUTION_AMOUNT = 40
  # ~weekly
  MAX_CONTRIBUTION_FREQUENCY = 1

  validates_presence_of :conf, :value, :units

  enum units: %i[amount seconds minutes days weeks months years]

  def fetch
    if units == 'amount'
      value
    else
      value.send(units)
    end
  end

  def self.latest_job
    create_with(value: LATEST_JOB, units: :months).find_or_create_by(conf: :latest_job)
  end

  def self.min_jobs
    create_with(value: MIN_JOBS, units: :amount).find_or_create_by(conf: :min_jobs)
  end

  def self.min_contributions
    create_with(value: MIN_CONTRIBUTIONS, units: :amount).find_or_create_by(conf: :min_contributions)
  end

  def self.latest_contribution
    create_with(value: LATEST_CONTRIBUTION, units: :months).find_or_create_by(conf: :latest_contribution)
  end

  def self.max_contribution_amount
    create_with(value: MAX_CONTRIBUTION_AMOUNT, units: :amount).find_or_create_by(conf: :max_contribution_amount)
  end 

  def self.max_contribution_frequency
    create_with(value: MAX_CONTRIBUTION_FREQUENCY, units: :months).find_or_create_by(conf: :max_contribution_frequency)
  end 
end
