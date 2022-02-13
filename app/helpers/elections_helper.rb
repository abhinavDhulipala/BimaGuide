module ElectionsHelper
  def highlight_row(election)
    return '' if election.expired?
    election.voted?(current_employee) ? 'table-success' : 'table-warning'
  end

  def term_limit
    Config.admin_term.fetch.inspect
  end

  def viable_employees
    # force evaluation for all employees.
    Employee.where.not(current_employee).filter {|emp| emp.role != 'contributor'}
  end

  def render_date(election)
    "end#{election.expired? ? 'ed at' : 's on'} #{display_time(election.ends_at)}"
  end
end
