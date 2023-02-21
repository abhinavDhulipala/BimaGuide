# frozen_string_literal: true

require 'test_helper'

class ElectionStartJobTest < ActiveJob::TestCase
  test 'fire with valid previous election' do
    assert_difference('AdminElection.count', 1) { ElectionStartJob.perform_now }
  end
  test 'fire with no admin; first time election' do
    AdminElection.destroy_all
    assert_difference('AdminElection.count', 1) { ElectionStartJob.perform_now }
    assert_enqueued_jobs 1
  end

  test "don't fire with recently created election" do
    AdminElection.start_election
    assert_no_difference 'Election.count' do
      ElectionStartJob.perform_now
    end
  end

  test 'assert error when trying to start an election too close to another' do
    AdminElection.start_election

    # start admin election is never called
    assert_no_difference('AdminElection.count') { ElectionStartJob.perform_now }
  end

  test 'election starts with proper triggers, previous admin does not exist' do
    freeze_time
    assert_enqueued_with(job: ElectionCloseJob, at: Config.election_length.fetch.since) do
      election = AdminElection.start_election
      assert_predicate election, :active?
      assert_equal election.ends_at, Config.election_length.fetch.since
    end
  end
end
