ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require 'faker'
require 'helpers/fixture_file_helpers.rb'
require 'minitest/spec'
ActiveRecord::FixtureSet.context_class.send :include, FixtureFileHelpers


class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
