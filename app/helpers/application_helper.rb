module ApplicationHelper
  def show_election?
    Election.pending_elections(current_employee).any?
  end
end
