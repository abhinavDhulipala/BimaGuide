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
    mock_vote election
    election.close_election
    assert_equal election.winner, Employee.order(:id)[6]
    assert_predicate election.winner, :admin?
    assert Election.admin_elect_exists?
  end

  test 'election time triggered end' do
    election = nil
    assert_enqueued_with(job: ElectionCloseJob, at: Config.election_length.fetch + 1.minute) do
      election = Election.start_admin_election
    end

    ElectionTest.mock_vote election
    travel_to Config.admin_term.fetch.since + 1.day
    puts DateTime.current
    refute_predicate election, :active?
  end

  def self.mock_vote(election)
    employees = Employee.order(:id)
    candidate1, candidate2, candidate3 = employees[6].id, employees[4].id, employees[2].id
    employees[0..5].each {|emp| election.votes.create!(voter: emp.id, candidate: candidate1)}
    employees[6..8].each {|emp| election.votes.create!(voter: emp.id, candidate: candidate2)}
    employees[9..10].each {|emp| election.votes.create!(voter: emp.id, candidate: candidate3)}
  end
  end
