module ContributionsHelper
    def max_amount
      Config.take.max_contribution_amount
    end
end
