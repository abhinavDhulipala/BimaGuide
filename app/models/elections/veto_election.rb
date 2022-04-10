class Elections::VetoElection < Election
  validates

  private
  def check_vote_val
    errors.add(:candidate, '"candidate value" must be either true or false') if %W[true false].include?(self.candidate)
  end
end
