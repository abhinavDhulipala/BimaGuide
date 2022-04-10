class AdminElection < Election

  def close_election
    super
    # winner can be none if no one votes. Maybe we should make this an error.
    # current behavior will result in a carry over of the previous admin
    winner&.update(role: 'admin')
  end

  def self.start_election
    if exists?
      current_admin.update(role: 'member')
    end

    new_election = super
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

  def self.check_active_elects
    where(active: true).where('ends_at < ?', DateTime.current).each do |election|
      election.close_election
    end
  end

  def self.latest_election
    order(:ends_at).last
  end
end
