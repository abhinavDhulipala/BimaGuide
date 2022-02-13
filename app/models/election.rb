class Election < ApplicationRecord
    has_many :votes
    validates_presence_of :election_type, :ends_at, on: :create
    validate :no_duplicate_admin_election, on: :create
    enum election_type: %w[admin_elect claim_elect], _default: 'admin_elect'

    def self.active_elections
        where(active: true)
    end

    def close_election
        return nil unless active?
        update!(active: false)
        # winner can be none if no one votes. Maybe we should make this an error.
        # current behavior will result in a carry over of the previous admin
        winner&.update(role: 'admin')
    end

    def vote(current_employee, candidate)
        votes.create(voter: current_employee.id, candidate: candidate)
    end

    def voted?(employee)
        votes.exists?(voter: employee)
    end

    def expired?
        DateTime.current > ends_at
    end

    def winner
        winner_id = votes.group(:candidate).count.max_by {|_, v| v}
        return nil unless winner_id.present?
        Employee.find(winner_id[0])
    end

    def self.current_admin
        # admins are only valid if they've been elected within 3 months
        latest_admin_elect = admin_elect.where(active: false).order(:ends_at).last
        return nil unless latest_admin_elect.present?
        latest_admin_elect.winner
    end

    def self.previous_terms(employee)
        admin_elect.where(active: false).filter {|e| e.winner == employee}.count
    end

    def self.admin_elect_exists?
        current_admin.present?
    end

    def self.pending_elections(employee)
        active_elections.order(:ends_at).filter { |election| not election.voted?(employee) }
    end

    def self.start_admin_election
        elect = create(election_type: :admin_elect, active: true, ends_at: Config.election_length.fetch.since)
        return nil unless elect.persisted?
        if admin_elect_exists?
            current_admin.update(role: 'member')
        end
        ElectionCloseJob.set(wait_until: elect.ends_at).perform_later(elect)
        elect
    end

    private

    def no_duplicate_admin_election
        if Election.admin_elect.active_elections.exists?
            errors.add(:election_type, 'cannot have two admin elections at the same time')
        end
    end
end
