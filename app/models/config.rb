class Config < ApplicationRecord
  
  # Time units x -> x.month(s).ago, unless otherwise specified
  # How many months since the last job, to be considered active. 
  LATEST_JOB = 12
  MIN_JOBS = 4
  MIN_CONTRIBUTIONS = 19
  LATEST_CONTIRBUTION = 4
  
  # Maximum USD value of a single contribution
  MAX_CONTRIBUTION_AMOUNT = 40
  # ~weekly
  MAX_CONTRIBUTION_FREQUENCY = 1

  enum units: %i[amount seconds minutes days months years]

  def fetch
    if units != :amount
      value.send(units)
    end
    value
  end

  def self.latest_job
    find_by(conf: :latest_job) or create(conf: :latest_job, value: LATEST_JOB, units: :months)
  end

  def self.min_jobs
    find_by(conf: :min_jobs) or create(conf: :min_jobs, value: MIN_JOBS, units: :amount)
  end

  def self.min_contributions
    find_by(conf: :min_contributions) or create(conf: :min_contributions, value: MIN_CONTRIBUTIONS, units: :amount)
  end

  def self.latest_contributions
    find_by(conf: :latest_contributions) or create(conf: :latest_contributions, value: LATEST_CONTRIBUTIONS, units: :months)
  end

  def self.max_contribution_amount
    config = find_by(conf: :max_contribution_amount) ||
    create(conf: :max_contribution_amount, value: MAX_CONTRIBUTION_AMOUNT, units: :amount)
    config.value
  end 

  def self.max_contribution_frequency
    config = find_by(conf: :max_contribution_frequency) ||
     create(conf: :max_contribution_frequency, value: MAX_CONTRIBUTION_FREQUENCY, units: :months)
    config.value.send(config.units)
  end 
end
