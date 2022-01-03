require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  test 'create validations' do 
    assert_raises(ActiveRecord::RecordInvalid) do 
      Employee.create! email: 'abc@berkeley.edu', password: 'yeet123', 
      occupation: 'blah', first_name: 'abhi', last_name: 'd'
    end
    assert_raises(ActiveRecord::RecordInvalid) do 
      Employee.create! email: 'abc@berkeley.edu', password: 'yeet123',
      occupation: 'porter', last_name: 'd'
    end
    assert_raises(ActiveRecord::RecordInvalid) do 
      Employee.create! email: 'abc@berkeley.edu', password: 'yeet123', 
      occupation: 'porter', last_name: 'd'
    end

    assert_difference ->{Employee.count}, 2 do 
      Employee.create! email: 'abc@berkeley.edu', password: 'yeet123',
      occupation: 'porter', first_name: 'abhi', last_name: 'd'
      Employee.create! email: 'abcd@berkeley.edu', password: 'yeet123',
      occupation: 'guide', first_name: 'abhi', last_name: 'd'
    end
  end

  test 'no duplicate emails' do 
    assert_difference ->{Employee.count}, 1 do 
      3.times {Employee.create email: 'abc@berkeley.edu', password: 'yeet123', 
                occupation: 'porter', first_name: 'abhi', last_name: 'd'}
    end
  end
end
