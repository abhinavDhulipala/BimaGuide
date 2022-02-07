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
    refute Election.admin_exists?
    election = Election.create!(election_type: :admin_elect, active: true, ends_at: 1.week.since)
    mock_vote election
    election.close_election
    assert_equal election.winner, Employee.order(:id)[6]
    assert Election.admin_exists?
  end

  test 'election ' do
    refute Election.admin_exists?
    election = Election.create!(election_type: :admin_elect, active: true, ends_at: 1.week.since)
    mock_vote election
    travel_to 1.week.since + 1.hour
    Election.poll_close_elections
    refute election.active?
    assert_equal election.winner, Employee.order(:id)[6]
    assert Election.admin_exists?
  end

  private

  def mock_vote(election)
    employees = Employee.order(:id)
    candidate1, candidate2, candidate3 = employees[6].id, employees[4].id, employees[2].id
    Employee.order(:id)[0..5].each {|emp| election.votes.create!(voter: emp.id, candidate: candidate1)}
    Employee.order(:id)[6..8].each {|emp| election.votes.create!(voter: emp.id, candidate: candidate2)}
    Employee.order(:id)[9..10].each {|emp| election.votes.create!(voter: emp.id, candidate: candidate3)}
    end
  end
