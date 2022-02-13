require "test_helper"

class ElectionCloseJobTest < ActiveJob::TestCase

  test 'happy path; starts new election after term ends' do
    election = elections(:stale_admin)
    election.update(active: true, ends_at: 0.days.ago)
    assert_enqueued_with(job: ElectionStartJob, at: Config.admin_term.fetch.since) do
      ElectionCloseJob.perform_now(election)
    end
    refute_predicate election, :active?
  end
end
