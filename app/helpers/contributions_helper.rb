# frozen_string_literal: true

module ContributionsHelper
  def max_amount
    Config.max_contribution_amount.fetch
  end
end
