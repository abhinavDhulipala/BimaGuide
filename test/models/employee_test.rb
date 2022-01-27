require "test_helper"

class EmployeeTest < ActiveSupport::TestCase

  setup do
    @employee = employees(:default)
  end

  test 'create validations' do 
    assert_raises(ArgumentError) do 
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

  test 'before_save::downcase' do 
    @employee.update! first_name: 'ABhi', last_name: 'SUAvE'
    assert_equal @employee.first_name, 'abhi'
    assert_equal @employee.last_name, 'suave'

    @employee.update! first_name: 'abhi', last_name: 'suave'
    assert_equal @employee.first_name, 'abhi'
    assert_equal @employee.last_name, 'suave'
      
  end

  test 'no duplicate emails' do 
    assert_difference ->{Employee.count}, 1 do 
      email = Faker::Internet.unique.email
      3.times {Employee.create email: email, password: 'yeet123', 
                occupation: 'porter', first_name: 'abhi', last_name: 'd'}
    end
  end

  test 'phone format validation' do 
    assert_raises(ActiveRecord::RecordInvalid) do 
      @employee.update!(phone: '-9283592')
    end 

    #Employee.create! email: 'abc@berkeley.edu', password: 'yeet123',
     # occupation: 'porter', first_name: 'abhi', last_name: 'd', phone: '4082525555'
    @employee.update! phone: '+1 (408)-252-5555'
    @employee.update! phone: '+255 75 099 5366'
    @employee.update! phone: '+255 750995366'
    @employee.update! phone: '+255 (75)-099-5366'    

  end

  test 'find latest contribution time' do 
    latest = @employee.contributions.create! amount: 1, purpose: 'regular payment'
    assert_equal latest.created_at, @employee.latest_contribution_date
  end

  test 'unintialized attributes' do 
    assert_equal @employee.unintialized_attrs, Employee::ADDITIONAL_INFO
    @employee.update! phone: '+255 750995366'
    assert_equal @employee.unintialized_attrs, %w[address1 zip]
    @employee.update! address1: 'blah', address2: 'blah', zip: 88888
    assert_empty @employee.unintialized_attrs
  end

  test 'pay gem compatibility' do 
    # must respond to name, first_name, last_name, pay_customer_name
    assert_equal @employee.name, 'Rico Suave'
    assert_equal @employee.pay_customer_name, 'Rico Suave'

  end
end
 
