class Election < ApplicationRecord
    has_many :votes
    enum election_type: %w[admin_elect claim_elect], _default: 'admin_elect'
    validates_presence_of :election_type, :active, :ends_at, on: :create
    before_create :no_duplicate_admin_election
    #after_create :close_election, if: votes.count == Employee.all.filter{|e| e.privileged?}.count

    def self.active_elections
        where(active: true)
    end

    def close_election
        return nil unless active?
        update!(active: false)
        winner.update(role: 'admin')
    end

    def winner
        winner_id = votes.group(:candidate).count.max_by {|_, v| v}
        return nil unless winner_id.present?
        Employee.find(winner_id[0])
    end

    def self.current_admin
        # admins are only valid if they've been elected within 3 months
        admin_elect.where(active: false).where(ends_at: Config.admin_term.fetch.ago..).order(:ends_at).last
    end

    def self.admin_elect_exists?
        current_admin.present?
    end

    def self.start_admin_election
        if admin_elect_exists?
            current_admin.update(role: 'member')
        end
        elect = create!(election_type: :admin_elect, active: true, ends_at: Config.election_length.fetch.since)
        # add a buffer for queue timing
        ElectionCloseJob.set(wait: Config.election_length.fetch + 1.minute).perform_later(elect)
        elect
    end

    private

    def no_duplicate_admin_election
        if admin_elect? && Election.admin_elect_exists?
            errors.add(:election_type, 'cannot have two admin elections at the same time')
        end
    end
end
