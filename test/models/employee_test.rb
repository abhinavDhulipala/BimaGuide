require "test_helper"

class EmployeeTest < ActiveSupport::TestCase

  before do
    @employee = Employee.create(first_name: Faker::Name.name,
                                  last_name: Faker::Name.name,
                                  occupation: 'porter',
                                  )
  end

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

  test 'phone format validation' do 
    assert_raises(ActiveRecord::RecordInvalid) do 
      Employee.create! email: 'abc@berkeley.edu', password: 'yeet123',
      occupation: 'porter', first_name: 'abhi', last_name: 'd', phone: '-9283592'
    end 

    #Employee.create! email: 'abc@berkeley.edu', password: 'yeet123',
     # occupation: 'porter', first_name: 'abhi', last_name: 'd', phone: '4082525555'
    Employee.create! email: 'abcd@berkeley.edu', password: 'yeet123',
      occupation: 'porter', first_name: 'abhi', last_name: 'd', phone: '+1 4082525555'
    Employee.create! email: 'abc@berkeley.edu', password: 'yeet123',
      occupation: 'porter', first_name: 'abhi', last_name: 'd', phone: '(408)-252-5555'
  end
end
 