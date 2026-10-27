ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Rate limits are counted in the cache, which outlives the transaction each
    # test is rolled back in -- and rolled back ids get reused, so one test's
    # attempts would otherwise count against the next one's.
    setup { Rails.cache.clear }

    # Add more helper methods to be used by all tests here...
    def acting_as(user)
      post login_path, params: { email: user.email, password: 'password' }

      self
    end

    def current_auth
      SessionGuard.new(name: 'web', session: session)
    end

    def assert_authenticated
      assert is_authenticated, 'The user is not authenticated'
    end

    def assert_guest
      assert_not is_authenticated, 'The user is authenticated'
    end

    private

    def is_authenticated
      current_auth.check?
    end
  end
end
