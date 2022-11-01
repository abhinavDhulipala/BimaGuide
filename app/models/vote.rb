# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :election
  validates :voter, :candidate, presence: { on: :create }
  validates :voter, uniqueness: { scope: :election_id, on: :create }
  validate :vote_within_deadline, on: :create
  validate :cannot_vote_for_yourself, on: :create
  validate :voter_must_be_privileged, on: :create

  private

  def voter_must_be_privileged
    errors.add(:voter, 'insufficient privileges; must be a member') unless Employee.find_by(id: voter)&.privileged?
  end

  def vote_within_deadline
    errors.add(:election_id, 'election has ended') unless election.active?
  end

  def cannot_vote_for_yourself
    errors.add(:candidate, 'cannot vote for yourself') if voter == candidate
  end
end
