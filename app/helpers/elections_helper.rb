module ElectionsHelper
  def highlight_row(election)
    return '' if election.expired?
    election.voted?(current_employee) ? 'table-success' : 'table-warning'
  end

  def term_limit
    limit = Config.admin_term
    "#{limit.value} #{limit.units}"
  end

  def viable_employees
    # force evaluation for all employees.
    Employee.where.not(current_employee).filter {|emp| emp.role != 'contributor'}
  end
end
