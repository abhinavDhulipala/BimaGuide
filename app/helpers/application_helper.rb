module ApplicationHelper
  def show_election?
    Election.pending_elections(current_employee).any?
  end

  def display_time(time)
    Time.at(time).strftime('%b %e, %C at %k:%M %p')
  end
end
