# frozen_string_literal: true

require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  setup do
    @employee = employees(:default)
    Config.min_jobs.update! value: 1
    Config.min_contributions.update! value: 1
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
      3.times do
        Employee.create email: email, password: 'yeet123',
                        occupation: 'porter', first_name: 'abhi', last_name: 'd'
      end
    end
  end

  test 'phone format validation' do
    assert_not @employee.update(phone: '-9283592')
    @employee.update! phone: '+1 (408)-252-5555'
    @employee.update! phone: '+255 75 099 5366'
    @employee.update! phone: '+255 750995366'
    @employee.update! phone: '+255 (75)-099-5366'
  end

  test 'find latest contribution time' do
    @employee.contributions.destroy_all
    latest = @employee.contributions.create! amount: 1, purpose: 'regular payment'
    assert_equal latest.created_at, @employee.latest_contribution_date
  end

  test 'pay gem compatibility' do
    # must respond to name, first_name, last_name, pay_customer_name
    assert_equal @employee.name, 'Rico Suave'
    assert_equal @employee.pay_customer_name, 'Rico Suave'
  end

  test 'employee is a member' do
    assert_equal @employee.role, 'member'
  end

  test 'employee is a role, insufficient min jobs' do
    Config.min_jobs.update value: 20
    assert_equal @employee.role, 'contributor'
  end

  test 'employee is a role, insufficient min contributions' do
    Config.min_contributions.update value: 20
    assert_equal @employee.role, 'contributor'
  end

  test 'employee is a role, insufficient latest contributions' do
    Config.latest_contribution.update! value: 1, units: :days
    assert_equal @employee.role, 'contributor'
  end

  test 'set test member' do
    employee = Employee.create()
  end
end
