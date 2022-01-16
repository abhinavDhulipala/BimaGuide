class EmployeesController < ApplicationController
  before_action :set_employee, except: %i[index about]
  before_action :authenticate_employee!, except: %i[ index about ]

  @display_notifications = true

  # GET /employees or /employees.json
  def index
  end


  def show
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees or /employees.json
  def create
    @employee = Employee.new(employee_params)

  end

  # PATCH/PUT /employees/1 or /employees/1.json
  def update; end

  # DELETE /employees/1 or /employees/1.json
  def destroy
    @employee.destroy
  end

  def dismiss_notifications 
    @display_notifications = false
    redirect_to employee_path(@employee)
  end


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
