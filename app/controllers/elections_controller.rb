class ElectionsController < ApplicationController
  before_action :set_election, only: %i[ show edit update destroy ]

  # GET /elections or /elections.json
  def index
    @elections = Election.active_elections
  end

  # GET /elections/1 or /elections/1.json
  def show
  end

  # GET /elections/new
  def new
    @election = Election.new
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_election
      @election = Election.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def election_params
      params.require(:election).permit(:index, :show)
    end
end
