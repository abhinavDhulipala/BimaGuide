# frozen_string_literal: true

module ElectionsHelper
  def highlight_row(election)
    if election.expired?
      'table-secondary'
    elsif election.voted?(current_employee)
      'table-success'
    else
      'table-warning'
    end
  end

  def term_limit
    Config.admin_term.fetch.inspect
  end

  def post_admin_election_text(election)
    if election.voted?(current_employee)
      "You voted for: #{election.voted_for(current_employee).name}. Thanks for voting"
    else
      "We have no record of you voting for a candidate. Sorry. Make sure to take a look at the elections home page
       for the next election"
    end
  end

  def render_date(election)
    "end#{election.expired? ? 'ed at' : 's on'} #{display_time(election.ends_at)}"
  end
end
