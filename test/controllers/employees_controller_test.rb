# frozen_string_literal: true

require 'test_helper'

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:default)
  end

  test 'allow admin only views' do
    employee_admin_profile_path(@employee)
  end
end
