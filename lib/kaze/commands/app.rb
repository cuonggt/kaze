require 'thor'

THOR = Thor.new

class Kaze::Commands::App < Thor
  def self.exit_on_failure?() true end

  desc 'install [STACK]', 'Install the Kaze controllers and resources. Supported stacks: hotwire, react, vue.'
  def install(stack = 'hotwire')
    unless File.exist?("#{Dir.pwd}/bin/rails")
      say 'Kaze must be run in a new Rails application.', :red
      exit 1
    end

    # The stack installers stop at the first step that fails, so a falsy return
    # means the application is half-installed. Exiting non-zero keeps that from
    # passing silently in a script or a CI job.
    exit 1 unless StackFactory.make(stack.to_sym).install
  rescue => e
    say e.message, :red
    exit 1
  end

  desc 'version', 'Show Kaze version'
  def version
    puts Kaze::VERSION
  end
end
