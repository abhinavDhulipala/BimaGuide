require "test_helper"

class ElectionStartJobTest < ActiveJob::TestCase

  test 'happy; fire election after previous election' do
    Election.create!(active: false, ends_at: Config.admin_term.fetch.ago - Config.election_length.fetch,
                     election_type: :admin_elect)
    assert_difference('Election.count', 1) { ElectionStartJob.perform_now }
  end

  test 'fire with no admin; first time election' do
    Election.destroy_all
    assert_difference('Election.count', 1) { ElectionStartJob.perform_now }
    assert_enqueued_jobs 1
  end

  test "don't fire with recently created election" do
    Election.start_admin_election
    assert_no_difference 'Election.count' do
      ElectionStartJob.perform_now
    end
  end

  test 'assert error when trying to start an election too close to another' do
    Election.admin_elect.last.update!(ends_at: 1.day.ago)

    # start admin election is never called
    assert_no_difference('Election.count') { ElectionStartJob.perform_now }
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
