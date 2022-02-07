class Vote < ApplicationRecord
  belongs_to :election
  validates_presence_of :voter, :candidate
  validates_uniqueness_of :voter, scope: :election_id
  before_create :vote_within_deadline
  before_create :cannot_vote_for_yourself
  before_create :voter_must_be_privileged

  private

  def voter_must_be_privileged
    errors.add(:voter, 'insufficient privileges; must be a member') unless Election.find_by(id: voter)&.privileged?
  end

  def vote_within_deadline
    Election.poll_close_elections
    errors.add(:election_id, 'election has ended') unless election.active
  end

  def cannot_vote_for_yourself
    errors.add(:election_id, 'cannot vote for yourself') if voter == candidate
  end
end
