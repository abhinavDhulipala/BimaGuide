# frozen_string_literal: true

class ElectionStartJob < ApplicationJob
  queue_as :default

  def perform
    if Election.admin_elect.where(ends_at: Config.admin_term.fetch.ago..).exists?
      return logger.info "election already exists within a term period; this can happen when an admin
                           renounces a position or get vetoed by 90% of members"
    end
    Election.start_admin_election
  end
end
