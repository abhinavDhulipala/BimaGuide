# frozen_string_literal: true

require 'test_helper'

class ContributionTest < ActiveSupport::TestCase
  setup do
    Config.max_contribution_amount.update(value: 10)
    Config.max_contribution_frequency.update(value: 1)
  end

  test 'no recent contribution' do
    employee = employees(:default)
    employee.contributions.create(amount: Config.max_contribution_amount.fetch - 1, purpose: 'blah')
    contribution = employee.contributions.new(amount: Config.max_contribution_amount.fetch - 1)
    contribution.send(:no_recent_contribution)
    assert_equal contribution.errors.size, 1
    assert contribution.errors.key?(:created_at)
  end

  test 'over max amount' do
    employee = employees(:default)
    contribution = employee.contributions.new(amount: Config.max_contribution_amount.fetch + 1)
    contribution.send(:max_contrib_amount)
    assert_equal contribution.errors.size, 1
    assert contribution.errors.key?(:amount)
  end

  test 'successful contribution' do
    employee = employees(:default)
    employee.contributions.create!(amount: Config.max_contribution_amount.fetch - 1, purpose: 'blah',
                                   created_at: (2 * Config.max_contribution_frequency.fetch).ago)
    employee.contributions.create!(amount: Config.max_contribution_amount.fetch - 1, purpose: 'blah',
                                   created_at: (1 * Config.max_contribution_frequency.fetch).ago)
    employee.contributions.create!(amount: Config.max_contribution_amount.fetch - 1, purpose: 'blah')
  end
end
