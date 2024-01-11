# frozen_string_literal: true

class EmployeesController < ApplicationController
  before_action :set_employee
  before_action :authenticate_employee!
  before_action :set_election_notifications
  before_action :admin_only, only: %i[admin_profile index]

  # GET /employees or /employees.json
  def index
    @employees = Employee.all
  end

  def show; end

  def show_admin
    if AdminElection.current_admin.present?
      @employee = AdminElection.current_admin
      @previous_terms = AdminElection.elections_won(@employee)
      @terms_ends = AdminElection.latest_election.ends_at
    else
      flash[:info] = 'there currently is no admin, this means they have either been vetoed or an election is ongoing'
    end
  end

  def admin_profile
    redirect_to action: :index, method: :get if flash[:error]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = (params[:id] and Employee.find(params[:id])) or current_employee
  end

  # Only allow a list of trusted parameters through.
  def employee_params
    return unless params[:employee]

    params.require(:employee).permit(:first_name, :last_name, :role, :contributions, :email,
                                     :occupation)
  end

  def set_election_notifications
    @pending_elections = Election.pending_elections(current_employee)
  end

  def admin_only
    return if set_employee.admin?

    flash[:danger] = 'Must be an admin'
    redirect_to :root
  end
end
