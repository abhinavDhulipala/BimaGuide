# frozen_string_literal: true

class ElectionCloseJob < ApplicationJob
  queue_as :default

  def perform(election)
    # fire notification that this election has ended
    election.close_election
    ElectionStartJob.set(wait_until: Config.admin_term.fetch.since).perform_later
  end
end
