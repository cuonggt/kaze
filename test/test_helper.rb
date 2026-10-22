require 'minitest/autorun'
require 'fileutils'
require 'tmpdir'

require_relative '../lib/kaze'

module Kaze
  class TestCase < Minitest::Test
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
