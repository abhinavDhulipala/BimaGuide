class EmployeesController < ApplicationController
  before_action :set_employee, except: %i[index ]
  before_action :authenticate_employee!, except: %i[ index ]

  @display_notifications = true

  # GET /employees or /employees.json
  def index
    @employees = Employee.all
  end


  def show; end


  # DELETE /employees/1 or /employees/1.json
  def destroy
    @employee.destroy
  end

  def dismiss_notifications 
    @display_notifications = false
    redirect_to employee_path(@employee)
  end

  def about; end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = current_employee || Employee.find(params[:id])  
    end

    # Only allow a list of trusted parameters through.
    def employee_params
      params.require(:employee).permit(:first_name, :last_name, :role, :contributions, :email, :occupation) if params[:employee]
    end
end
