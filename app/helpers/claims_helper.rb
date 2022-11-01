# frozen_string_literal: true

module ClaimsHelper
  def max_claim_amount
    Config.max_claim_amount.fetch
  end
end
