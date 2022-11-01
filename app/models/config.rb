# frozen_string_literal: true

class Config < ApplicationRecord
  # Time units x -> x.month(s).ago, unless otherwise specified
  # How many months since the last job, to be considered active.
  LATEST_JOB = 12
  MIN_JOBS = 4
  JOB_LOG_LIMIT = 12
  MIN_CONTRIBUTIONS = 10
  LATEST_CONTRIBUTION = 4

  # Maximum USD value of a single contribution
  MAX_CONTRIBUTION_AMOUNT = 40
  # ~weekly
  MAX_CONTRIBUTION_FREQUENCY = 1
  ADMIN_TERM = 3
  ELECTION_LENGTH = 1

  MAX_CLAIMS_AMOUNT = 200
  MAX_CLAIMS_FREQUENCY = 1

  # max claims per year
  MAX_TOTAL_CLAIMS = 5

  DEVELOPER_EMAIL = 'abhinav.dhulipala@berkeley.edu'

  validates :conf, :value, :units, presence: true

  enum units: { amount: 0, days: 1, weeks: 2, months: 3, years: 4 }

  def fetch
    if amount?
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
    create_with(value: MAX_CONTRIBUTION_FREQUENCY, units: :weeks).find_or_create_by(conf: :max_contribution_frequency)
  end

  def self.admin_term
    create_with(value: ADMIN_TERM, units: :months).find_or_create_by(conf: :admin_term)
  end

  def self.election_length
    create_with(value: ELECTION_LENGTH, units: :weeks).find_or_create_by(conf: :election_length)
  end

  def self.job_log_limit
    create_with(value: JOB_LOG_LIMIT, units: :months).find_or_create_by(conf: :job_log_limit)
  end

  def self.max_claim_amount
    create_with(value: MAX_CLAIMS_AMOUNT, units: :amount).find_or_create_by(conf: :max_claim_amount)
  end
end
