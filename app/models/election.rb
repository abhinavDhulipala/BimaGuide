class Election < ApplicationRecord
    has_many :votes, dependent: :destroy
    validate :no_duplicate_election, on: :create

    before_create {self.vetoed = false}

    def self.active_elections
        where(active: true)
    end

    def close_election
        return nil unless active?
        update(active: false)
    end

    def vote(current_employee, candidate)
        cast = votes.find_by(voter: current_employee.id)
        if cast.present?
            cast.update(candidate: candidate)
        else
            cast = votes.create(voter: current_employee.id, candidate: candidate)
        end

        cast
    end

    def voted?(employee)
        votes.find_by(voter: employee)
    end

    def voted_for(employee)
      if voted?(employee)
        cast_vote = votes.find_by(voter: employee)
        Employee.find(cast_vote.candidate)
      end
    end

    def expired?
        if DateTime.current > ends_at
            close_election
        end

        not active?
    end

    def winner
        winner_ids = votes.group(:candidate).count.max_by {|_, v| v}
        return nil unless winner_ids.present?
        Employee.find(winner_ids.first)
    end

    def self.pending_elections(employee)
        active_elections.order(:ends_at).filter { |election| not election.voted?(employee) }
    end

    def self.start_election
        elect = create(active: true, ends_at: Config.election_length.fetch.since)
        unless elect.persisted?
            logger.info "election creation failed due to #{elect.errors.messages}"
            return nil
        end
    end

    private

    def no_duplicate_election
        if Election.active_elections.exists?
            errors.add(:election_type, 'cannot have two admin elections at the same time')
        end
    end
end
