class ElectionStartJob < ApplicationJob
  queue_as :default

  def perform
    # fire an election every Config months unless a veto has been set in place
    most_recent_election_date = Election.admin_elect.order(:ends_at).pluck(:ends_at)&.last
    raise 'election has been fired within term limits' if most_recent_election_date.present? &&
      most_recent_election_date > Config.admin_term.fetch.ago
      Election.start_admin_election
  end
end
