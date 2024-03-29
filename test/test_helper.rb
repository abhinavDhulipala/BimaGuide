# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'faker'
require 'helpers/fixture_file_helpers'
require 'minitest/spec'
require 'minitest/mock'
require 'sidekiq/delay_extensions/testing'
ActiveRecord::FixtureSet.context_class.send :include, FixtureFileHelpers

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
