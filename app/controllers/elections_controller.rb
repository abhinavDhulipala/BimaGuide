# frozen_string_literal: true

class ElectionsController < ApplicationController
  before_action :set_election, except: %i[index]
  before_action :refresh_active_elections, except: %i[vote]
  before_action :authenticate_employee!

  def index
    @elections = Election.order(ends_at: :desc)
  end

  def show
    @vote = @election.voted_for(current_employee)
    @vote ||= @election.votes.new
    @candidates = current_employee.votable_employees
  end

  def vote
    @vote = @election.vote(current_employee, vote_params[:candidate])
    if @vote.persisted?
      redirect_to employee_elections_url(current_employee), notice: 'Vote successfully cast'
    else
      @candidates = current_employee.votable_employees
      render :show, status: :unprocessable_entity
    end
  end

  def veto; end

  private

  def refresh_active_elections
    AdminElection.check_active_elects
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_election
    @election = Election.find(params[:id] || params[:election_id])
  end

  # Only allow a list of trusted parameters through.
  def election_params
    params.require(:election).permit(:index, :show)
  end

  def vote_params
    params[:vote] = params[:employee] if params.key?(:employee)
    params.require(:vote).permit(:candidate)
  end
end
