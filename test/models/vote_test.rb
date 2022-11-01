# frozen_string_literal: true

require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  setup do
    @employee = employees(:default)
    @employee.update!(role: 'admin')
    @candidate = employees(:candidate)
    @election = Election.create!(election_type: :admin_elect, active: true, ends_at: 1.week.since)
  end

  test 'no duplicate votes' do
    assert_predicate @election.votes.create(voter: @employee.id, candidate: @candidate.id), :persisted?
    dup = @election.votes.create(voter: @employee.id, candidate: @candidate.id)
    assert_not_predicate dup, :persisted?
    assert_equal dup.errors.size, 1
    assert_equal dup.errors.messages[:voter], ['has already been taken']
  end

  test 'voter expiration' do
    @election.update(active: false)
    time_expired = @election.votes.create(voter: @employee.id, candidate: @candidate.id)
    assert_not_predicate time_expired, :persisted?
    assert_equal time_expired.errors.size, 1
    assert_equal time_expired.errors.messages[:election_id], ['election has ended']
  end

  test 'cannot vote for yourself' do
    vote_self = @election.votes.create(voter: @employee.id, candidate: @employee.id)
    assert_not_predicate vote_self, :persisted?
    assert_equal vote_self.errors.size, 1
    assert_equal vote_self.errors.messages[:candidate], ['cannot vote for yourself']
  end

  test 'happy path' do
    assert_predicate @election.votes.create(voter: @employee.id, candidate: @candidate.id), :persisted?
  end

  test 'no pending elections' do
    Election.destroy_all
    assert_empty Election.pending_elections(@employee)
  end

  test 'no active elections pending' do
    Election.active_elections.each(&:close_election)
    assert_empty Election.pending_elections(@employee)
  end

  test 'happy; 2 pending elections' do
    assert_equal Election.pending_elections(@employee).count, 2
  end

  test 'reflects employee casting vote' do
    @election.votes.create(voter: @employee.id, candidate: @candidate.id)
    assert_equal Election.pending_elections(@employee).count, 1
  end
end
