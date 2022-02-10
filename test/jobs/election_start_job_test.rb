require "test_helper"

class ElectionStartJobTest < ActiveJob::TestCase
  test 'election start happy' do
    Election.stub(:start_admin_election, nil) { ElectionStartJob.perform_now }
  end
  test 'fire with no admin; first time election' do
    Election.destroy_all
    Election.stub(:start_admin_election, nil) do
      ElectionStartJob.perform_now
    end
  end

  test 'assert error when trying to start an election too close to another' do
    Election.admin_elect.last.update!(ends_at: 1.day.ago)
    # election
    assert_enqueued_jobs 0
    Election.stub(:start_admin_election, nil) { ElectionStartJob.perform_now }
    assert_enqueued_jobs 0
  end

  test 'election starts with proper triggers, previous admin does not exist' do
    freeze_time
    assert_enqueued_with(job: ElectionCloseJob, at: Config.election_length.fetch.since) do
      election = Election.start_admin_election
      assert_predicate election, :active?
      assert_equal election.ends_at, Config.election_length.fetch.since
    end
  end

end
