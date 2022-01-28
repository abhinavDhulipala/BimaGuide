class Config < ApplicationRecord
  # Singleton for global configs
  validate ->{errors.add(:base, 'record already exists') if Config.count > 0}, on: :create
  MIN_JOBS = 4
  # How many months since the last job, to be considered active. 
  LATEST_JOB = 12
  MIN_CONTRIBUTIONS = 19
  LATEST_CONTIRBUTION = 4

  # Over ride class single access
  def self.take 
    unless exists?
      puts 'created'
      return create(min_jobs: MIN_JOBS, latest_job: LATEST_CONTIRBUTION,
       latest_contribution: LATEST_CONTIRBUTION, min_contributions: MIN_CONTRIBUTIONS)
      end
    super
  end

  def self.first 
    take
  end

  def self.last
    take
  end
end
