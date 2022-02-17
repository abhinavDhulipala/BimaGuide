module ApplicationHelper
  def show_election?
    Election.pending_elections(current_employee).any?
  end

  # standardized time method to be used wherever a datetime needs to be displayed
  def display_time(time)
    Time.at(time).strftime('%b %e, %C at %k:%M %p')
  end
end
