require "test_helper"

class ElectionStartJobTest < ActiveJob::TestCase
  test 'election start happy' do
    Election.stub(:start_admin_election, nil) { ElectionStartJob.perform_now }
  end
  test 'fire with no admin; first time election' do
    Election.destroy_all
    Election.stub(:start_admin_election, nil) { ElectionStartJob.perform_now }
  end

  test 'assert error when trying to start an election too close to another' do
    Election.admin_elect.last.update!(ends_at: 1.day.ago)
    error = assert_raises RuntimeError do
      Election.stub(:start_admin_election, nil) { ElectionStartJob.perform_now }
    end
    assert_equal 'election has been fired within term limits', error.message
  end
end
