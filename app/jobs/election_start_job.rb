class ElectionStartJob < ApplicationJob
  queue_as :default


  def perform
    # fire an election every Config months unless a veto has been set in place
    most_recent_election_date = Election.admin_elect.order(:ends_at).pluck(:ends_at)&.last
    if most_recent_election_date.present? && most_recent_election_date > Config.admin_term.fetch.ago
      return logger.info "election already exists within a term period; this can happen when an admin
                           renounces a position or get vetoed by 90% of members"
    end
    Election.start_admin_election
  end
end
