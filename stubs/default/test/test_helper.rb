ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# Build the frontend once, here in the parent process, before `parallelize`
# forks its workers. Vite Ruby builds on demand and guards it with a Mutex,
# which only holds within a process: each worker would otherwise start its own
# `vite build` against the same manifest, and a worker that read it
# half-written failed with "Unexpected end of JSON input". A first run is the
# only one exposed -- afterwards there is nothing left to build -- which is
# exactly the run a fresh checkout on CI does.
if defined?(ViteRuby) && !ViteRuby.instance.dev_server_running?
  abort 'Vite build failed. Run `bin/vite build --mode=test` to see why.' unless ViteRuby.commands.build
end

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
