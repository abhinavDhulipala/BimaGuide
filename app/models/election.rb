class Election < ApplicationRecord
    has_many :votes
    enum election_type: %w[admin_elect claim_elect], _default: 'admin_elect'
    validates_presence_of :election_type, :active, :ends_at, on: :create
    before_create :no_duplicate_admin_election

    def self.active_elections
        where(active: true)
    end

    def close_election
        # todo: add email notifications background job
        update!(active: false)
    end

    def winner
        winner_id = votes.group(:candidate).count.max_by {|_, v| v}[0]
        Employee.find(winner_id)
    end

    def self.current_admin
        # admins are only valid if they've been elected within 3 months
        admin_elect.where(active: false).where(ends_at: 3.months.ago..).order(:ends_at).last
    end

    def self.admin_exists?
        current_admin.present?
    end

    def self.poll_close_elections
        active_elections.each do |elect|
            elect.close_election if DateTime.current > elect.ends_at
        end
        active_elections
    end

    private

    def no_duplicate_admin_election
        if admin_elect? && Election.admin_exists?
            errors.add(:election_type, 'cannot have two admin elections at the same time')
        end
    end
end
