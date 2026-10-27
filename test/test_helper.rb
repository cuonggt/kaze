require 'minitest/autorun'
require 'fileutils'
require 'tmpdir'

require_relative '../lib/kaze'
require_relative 'support/own_work'

module Kaze
  class TestCase < Minitest::Test
    # Install and upgrade always run over a real application rather than an
    # empty one, and the failures worth catching are the ones that only appear
    # with someone else's files sitting beside Kaze's: the migration rewrite
    # emptied every one of these for two years, and an empty fixture could
    # never have shown it. The CI upgrade job seeds the same set.
    OWN_WORK = Kaze::OwnWork::FILES

    # The one file of the application's that Kaze does edit, rather than leaves
    # alone -- trimmed to the lines that matter here.
    TEST_ENVIRONMENT = "Rails.application.configure do\n" \
                       "  config.enable_reloading = false\n" \
                       "  config.cache_store = :null_store\n" \
                       "  config.action_mailer.delivery_method = :test\n" \
                       "end\n"

    private
      # Most of what the commands do is relative to Dir.pwd, so the tests run
      # inside a throwaway directory standing in for a scaffolded application.
      def in_app(files = [])
        Dir.mktmpdir('kaze-test') do |dir|
          FileUtils.touch("#{dir}/.keep")
          files.each do |path|
            FileUtils.mkdir_p("#{dir}/#{File.dirname(path)}")
            File.write("#{dir}/#{path}", "// #{path}\n")
          end

          Dir.chdir(dir) { yield dir }
        end
      end

      # in_app, plus the application's own work in the places Kaze writes to.
      def in_app_with_own_work(files = [])
        in_app(files) do |dir|
          write_own_work(dir)

          yield dir
        end
      end

      def write_own_work(dir)
        Kaze::OwnWork.write(dir)
      end

      # Byte for byte: a rewrite that emptied a file and one that reworded it
      # are the same mistake, and both are caught here.
      def assert_own_work_untouched(dir)
        assert_empty Kaze::OwnWork.damaged(dir), "the application's own work did not come through untouched"
      end

      # install_migrations asks the application which Rails it is on.
      def fake_rails(dir)
        FileUtils.mkdir_p("#{dir}/bin")
        File.write("#{dir}/bin/rails", "#!/bin/sh\necho 'Rails 8.1.0'\n")
        FileUtils.chmod(0o755, "#{dir}/bin/rails")
      end

      def stubs_path
        File.expand_path('../stubs', __dir__)
      end

      def stacks
        {
          hotwire: Kaze::Commands::App::HotwireStack,
          react: Kaze::Commands::App::InertiaReactStack,
          vue: Kaze::Commands::App::InertiaVueStack
        }
      end
  end
end
