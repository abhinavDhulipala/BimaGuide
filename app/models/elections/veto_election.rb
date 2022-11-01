# frozen_string_literal: true

class VetoElection < Election
  validate :check_vote_val

  private

  def check_vote_val
    errors.add(:candidate, '"candidate value" must be either true or false') if %w[true false].include?(candidate)
  end
end
