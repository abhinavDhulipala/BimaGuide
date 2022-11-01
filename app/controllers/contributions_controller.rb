# frozen_string_literal: true

class ContributionsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_contribution, only: %i[show edit update destroy]

  VIEW_LIMIT = 100

  # GET /contributions or /contributions.json
  def index
    @contributions = current_employee.contributions.order(created_at: :desc)
    @privileged = privledged_access
    @contributions = Contribution.all if @privileged && (params[:current_employee_filter] == 'all')
  end

  # GET /contributions/1 or /contributions/1.json
  def show; end

  # GET /contributions/new
  def new
    @contribution = Contribution.new
  end

  # POST /contributions or /contributions.json
  def create
    @contribution = current_employee.contributions.create(contribution_params)
    if @contribution.persisted?
      redirect_to employee_contributions_path(current_employee), notice: 'Contribution was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def contribution_params
    params.require(:contribution).permit(:amount, :purpose)
  end

  # when a member graduates from being a contributer to a member
  # they qualify for claims fulfillment
  def privledged_access
    current_employee.role == 'member'
  end
end
