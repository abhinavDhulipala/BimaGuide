require "test_helper"

class ConfigTest < ActiveSupport::TestCase
  test 'max contribution amount' do
    byebug
    assert_equal Config.max_contribution_amount, Config::MAX_CONTRIBUTION_AMOUNT
    Config.find_by(conf: :max_contribution_amount).update value: 1
    assert_equal Config.max_contribution_amount, 1 
    
  end
  test 'take override' do 
    #assert_equal Config.take, 
  end
end
