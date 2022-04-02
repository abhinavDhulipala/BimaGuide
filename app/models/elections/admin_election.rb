class AdminElection < Election

  def close_election
    super
    # winner can be none if no one votes. Maybe we should make this an error.
    # current behavior will result in a carry over of the previous admin
    winner&.update(role: 'admin')
  end

  def self.start_election
    new_election = super
    if exists?
      current_admin.update(role: 'member')
    end
    return nil unless new_election.present?
    ElectionCloseJob.set(wait_until: new_election.ends_at).perform_later(new_election)
    VetoElection.start_election
    new_election
  end

  def self.current_admin
    latest_admin_elect = where(active: false).order(:ends_at).last
    if latest_admin_elect.present?
      latest_admin_elect.winner
    end
  end

  def self.elections_won(employee)
    where(winner: employee.id, active: false).count
  end
end
