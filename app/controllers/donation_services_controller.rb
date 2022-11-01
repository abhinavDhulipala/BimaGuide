# frozen_string_literal: true

class DonationServicesController < ApplicationController
  before_action :set_donation_service, only: %i[show edit update destroy]

  # GET /donation_services or /donation_services.json
  def index
    @donation_services = DonationService.all
  end

  # GET /donation_services/1 or /donation_services/1.json
  def show; end

  # GET /donation_services/new
  def new
    @donation_service = DonationService.new
  end

  # GET /donation_services/1/edit
  def edit; end

  # POST /donation_services or /donation_services.json
  def create
    @donation_service = DonationService.new(donation_service_params)

    respond_to do |format|
      if @donation_service.save
        format.html { redirect_to @donation_service, notice: 'Donation service was successfully created.' }
        format.json { render :show, status: :created, location: @donation_service }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @donation_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /donation_services/1 or /donation_services/1.json
  def update
    respond_to do |format|
      if @donation_service.update(donation_service_params)
        format.html { redirect_to @donation_service, notice: 'Donation service was successfully updated.' }
        format.json { render :show, status: :ok, location: @donation_service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @donation_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /donation_services/1 or /donation_services/1.json
  def destroy
    @donation_service.destroy
    respond_to do |format|
      format.html { redirect_to donation_services_url, notice: 'Donation service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_donation_service
    @donation_service = DonationService.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def donation_service_params
    params.fetch(:donation_service, {})
  end
end
