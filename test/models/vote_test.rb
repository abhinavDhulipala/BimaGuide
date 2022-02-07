require "test_helper"

class VoteTest < ActiveSupport::TestCase
  setup do
    @employee = employees(:default)
    @candidate = employees(:candidate)
    @election = Election.create!(election_type: :admin_elect, active: true, ends_at: 1.week.since)
  end

  test 'no duplicate votes' do
    assert_difference 'Vote.count', 1 do
      2.times {@election.votes.create(voter: @employee.id, candidate: @candidate.id)}
    end
  end

  test 'voter expiration' do
    travel_to 1.week.since + 1.hour
    refute_predicate @election.votes.create(voter: @employee.id, candidate: @candidate.id), :persisted?
    travel_back
    assert_predicate @election.votes.create(voter: @employee.id, candidate: @candidate.id), :persisted?
  end
end
