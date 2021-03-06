require "test_helper"

class ElectionTest < ActiveSupport::TestCase
  setup do
    Employee.destroy_all
    10.times do
      Employee.create!(first_name: Faker::Name.first_name,
                     last_name: Faker::Name.last_name,
                     email: Faker::Internet.unique.email,
                     occupation: Employee.occupations['porter'],
                     role: Employee.roles['member'],
                     password: 'encrypted_password')
    end
  end

  test 'election happy path' do
    refute Election.admin_elect_exists?
    election = Election.start_admin_election
    ElectionTest.mock_vote election
    election.close_election
    assert_equal election.winner, Employee.order(:id)[6]
    assert_predicate election.winner, :admin?
    assert Election.admin_elect_exists?
  end

  test 'correct calculation of winners' do
    election = Election.start_admin_election
    mocked_winner = ElectionTest.mock_vote election
    election.close_election
    assert_equal election.winner, mocked_winner
  end

  test 'winner is nil with no votes' do
    election = Election.start_admin_election
    election.close_election
    assert_nil election.winner
  end

  test 'no duplicate elections' do
    assert_difference('Election.count', 1) do
      2.times { Election.start_admin_election }
    end
  end

  test 'voted?' do
    election = Election.start_admin_election
    voter, candidate = Employee.all.sample(2)
    # give permission to vote
    voter.update!(role: :admin)
    refute election.voted?(voter)
    election.votes.create!(voter: voter.id, candidate: candidate.id)
    assert election.voted?(voter)
  end

  def self.mock_vote(election)
    employees = Employee.order(:id)
    winner, candidate2, candidate3 = employees[6].id, employees[4].id, employees[2].id
    employees[0..5].each {|emp| election.votes.create!(voter: emp.id, candidate: winner)}
    employees[6..8].each {|emp| election.votes.create!(voter: emp.id, candidate: candidate2)}
    employees[9..10].each {|emp| election.votes.create!(voter: emp.id, candidate: candidate3)}
    employees.find(winner)
  end
end
