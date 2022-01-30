require "test_helper"

class EmployeeTest < ActiveSupport::TestCase

  setup do
    @employee = employees(:default)
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
    assert_difference 'Employee.count', 1 do 
      email = Faker::Internet.unique.email
      3.times {Employee.create email: email, password: 'yeet123', 
                occupation: 'porter', first_name: 'abhi', last_name: 'd'}
    end
  end

  test 'phone format validation' do 
    refute @employee.update(phone: '-9283592')
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

  test 'role permissioning' do
    assert_equal @employee.role, 'contributor'
    Config.take.update!(min_jobs: 0, latest_job: 21,
       latest_contribution: 21, min_contributions: 0)
    assert_equal @employee.role, 'member'
    Config.take.update!(min_jobs: 3, latest_job: 21,
       latest_contribution: 21, min_contributions: 0)
    assert_equal @employee.role, 'contributor'
    Config.take.update!(min_jobs: 0, latest_job: 21,
       latest_contribution: 21, min_contributions: 10)
    assert_equal @employee.role, 'contributor'
    Config.take.update!(min_jobs: 0, latest_job: 21,
       latest_contribution: 21, min_contributions: 0)
    assert_equal @employee.role, 'member'
  end

  test 'permissioning, latest job' do 
    Config.take.update!(min_jobs: 0, latest_job: 1,
       latest_contribution: 21, min_contributions: 0)
    assert_equal @employee.role, 'member'
    Config.take.update! latest_job: 0

    assert_equal @employee.role, 'contributor'
    Config.take.update! latest_job: 2
    assert_equal @employee.role, 'member'

    Job.destroy_all
    assert_equal @employee.role, 'contributor'

  end

  test 'permissioning, latest contribution' do 
    Config.take.update!(min_jobs: 0, latest_job: 1,
       latest_contribution: 21, min_contributions: 0)
    assert_equal @employee.role, 'member'
    Config.take.update!(latest_contribution: 0)
    assert_equal @employee.role, 'contributor'
  end

  test 'permissioning, min jobs' do 
    Config.take.update!(min_jobs: 3, latest_job: 1,
       latest_contribution: 21, min_contributions: 0)
    assert_equal @employee.role, 'contributor'
    Config.take.update!(min_jobs: 0)
    assert_equal @employee.role, 'member'
    Job.destroy_all
    assert_equal @employee.role, 'contributor'
  end
end
 
