# frozen_string_literal: true

require 'test_helper'

class ElectionTest < ActiveSupport::TestCase
  setup do
    Employee.destroy_all
    10.times do
      emp = Employee.new(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         email: Faker::Internet.unique.email,
                         occupation: Employee.occupations['porter'],
                         role: Employee.roles['member'],
                         password: 'encrypted_password')
      emp.save!(validate: false)
    end
  end

  test 'no duplicate elections' do
    assert_difference('Election.count', 1) do
      2.times { Election.start_election }
    end
  end

  test 'voted?' do
    election = AdminElection.start_election
    voter, candidate = Employee.all.sample(2)
    # give permission to vote
    voter.update!(role: :admin)
    assert_not election.voted?(voter)
    election.votes.create!(voter: voter.id, candidate: candidate.id)
    assert election.voted?(voter)
  end

  def self.mock_vote(election)
    employees = Employee.order(:id)
    winner = employees[6].id
    candidate2 = employees[4].id
    candidate3 = employees[2].id
    employees[0..5].each { |emp| election.votes.create!(voter: emp.id, candidate: winner) }
    employees[6..8].each { |emp| election.votes.create!(voter: emp.id, candidate: candidate2) }
    employees[9..10].each { |emp| election.votes.create!(voter: emp.id, candidate: candidate3) }
    employees.find(winner)
  end
end
