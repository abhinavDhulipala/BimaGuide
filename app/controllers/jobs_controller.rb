class JobsController < ApplicationController
  before_action :set_job, only: %i[ show edit update destroy ]
  before_action :authenticate_employee!


  # GET /jobs or /jobs.json
  def index
    @jobs = current_employee.jobs.order(date_completed: :desc)
  end

  # GET /jobs/1
  def show; end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit; end

  # POST /jobs or /jobs.json
  def create
    @job = current_employee.jobs.create(job_params)
    if @job.persisted?
      redirect_to employee_jobs_url, notice: "Job was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /jobs/1 or /jobs/1.json
  def update
      if @job.update(job_params)
        redirect_to employee_jobs_path(current_employee), notice: "Job was successfully updated." 
      else
        render :edit, status: :unprocessable_entity 
      end
  end

  # DELETE /jobs/1 or /jobs/1.json
  def destroy
    unless @job.destroy
      render :edit, status: :unprocessable_entity
    end
    redirect_to employee_jobs_url(current_employee)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def job_params
      params.require(:job).permit %i[total_pay role date_completed date_started document]
    end
end
