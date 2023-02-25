# frozen_string_literal: true

class Election < ApplicationRecord
  has_many :votes, dependent: :destroy
  validate :no_duplicate_election, on: :create

  before_create { self.vetoed = false }

  def self.active_elections
    where(active: true)
  end

  def close_election
    return nil unless active?

    update(active: false)
  end

  def vote(current_employee, candidate)
    create_with(candidate: candidate).find_or_create_by(voter: current_employee.id)
  end

  def voted?(employee)
    votes.find_by(voter: employee)
  end

  def voted_for(employee)
    return unless voted?(employee)

    cast_vote = votes.find_by(voter: employee)
    Employee.find(cast_vote.candidate)
  end

  def expired?
    close_election if DateTime.current > ends_at

    !active?
  end

  def winner
    winner_ids = votes.group(:candidate).count.max_by { |_, v| v }
    return nil if winner_ids.blank?

    Employee.find(winner_ids.first)
  end

  def self.pending_elections(employee)
    return [] if Employee.roles[employee.role] < Employee.roles[:member]

    active_elections.order(:ends_at).reject { |election| election.voted?(employee) }
  end

  def self.start_election
    elect = create(active: true, ends_at: Config.election_length.fetch.since)
    if elect.persisted?
      elect
    else
      logger.info "election creation failed due to #{elect.errors.messages}"
    end
  end

  def self.elections_won(employee)
    where(winner: employee.id, active: false).count
  end

  def self.latest_election
    order(:ends_at).last
  end

  private

  def no_duplicate_election
    errors.add(:election_type, 'cannot have two admin elections at the same time') if Election.active_elections.exists?
  end
end
