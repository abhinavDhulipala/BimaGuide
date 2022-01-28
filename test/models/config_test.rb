require "test_helper"

class ConfigTest < ActiveSupport::TestCase
  test 'singleton config table' do
    assert_difference 'Config.count', 1 do 
      Config.create(min_jobs: 1, latest_job: 1, latest_contribution: 1, min_contributions: 1)
      Config.create(min_jobs: 1, latest_job: 1, latest_contribution: 1, min_contributions: 1)
      Config.new(min_jobs: 1, latest_job: 1, latest_contribution: 1, min_contributions: 1).save
    end
  end

  test 'take override' do 
    #assert_equal Config.take, 
  end
end
