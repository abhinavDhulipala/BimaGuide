# frozen_string_literal: true

class AdminElection < Election
  def close_election
    super
    # winner can be none if no one votes. Maybe we should make this an error.
    # current behavior will result in a carry over of the previous admin
    winner&.update(role: 'admin')
  end

  def self.start_election
    current_admin&.update(role: 'member')

    new_election = super
    return nil if new_election.blank?

    ElectionCloseJob.set(wait_until: new_election.ends_at).perform_later(new_election)
    VetoElection.last&.close_election
    VetoElection.start_election
    new_election
  end

  def self.current_admin
    latest_admin_elect = where(active: false).order(:ends_at).last
    latest_admin_elect.winner if latest_admin_elect.present?
  end

  def self.check_active_elects
    where(active: true).where('ends_at < ?', DateTime.current).find_each(&:close_election)
  end
end
