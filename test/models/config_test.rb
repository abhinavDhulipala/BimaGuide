require "test_helper"

class ConfigTest < ActiveSupport::TestCase
  test 'max contribution amount' do
    config = Config.max_contribution_amount
    assert_equal config.fetch, Config::MAX_CONTRIBUTION_AMOUNT
    config.update value: 1
    assert_equal config.fetch, 1 
  end

  test 'latest job' do
    config = Config.latest_job
    assert_equal config.fetch, Config::LATEST_JOB.months
    config.update value: 1
    assert_equal config.fetch, 1.month
  end

  test 'latest contribution' do
    config = Config.latest_contribution
    assert_equal config.fetch, Config::LATEST_CONTRIBUTION.month
    config.update value: 1
    assert_equal config.fetch, 1.month
  end
end
