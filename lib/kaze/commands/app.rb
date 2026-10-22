require 'thor'

THOR = Thor.new

class Kaze::Commands::App < Thor
  def self.exit_on_failure?() true end

  desc 'install [STACK]', 'Install the Kaze controllers and resources. Supported stacks: hotwire, react, vue.'
  def install(stack = 'hotwire')
    ensure_rails_application

    # The stack installers stop at the first step that fails, so a falsy return
    # means the application is half-installed. Exiting non-zero keeps that from
    # passing silently in a script or a CI job.
    exit 1 unless StackFactory.make(stack.to_sym).install
  rescue => e
    say e.message, :red
    exit 1
  end

  desc 'upgrade [STACK]', 'Remove files an earlier Kaze installed that this version no longer ships, then install.'
  method_option :force, type: :boolean, default: false, aliases: '-f', desc: 'Skip the confirmation prompt.'
  method_option :'dry-run', type: :boolean, default: false, desc: 'List what would be removed and stop.'
  def upgrade(stack = 'hotwire')
    ensure_rails_application

    stack = StackFactory.make(stack.to_sym)
    paths = stack.removable_paths

    if paths.empty?
      say 'Nothing to remove. This application has none of the files earlier versions installed.', :green
    else
      say "Kaze no longer ships #{paths.length} #{paths.length == 1 ? 'file' : 'files'} this application still has:", :yellow
      say ''
      paths.each { |path| say "  #{path}" }
      say ''
      say 'They are yours now, so check for your own changes before agreeing.', :yellow

      return if options[:'dry-run']

      unless options[:force] || yes?('Remove them? [y/N]')
        say 'Nothing was removed.', :red
        exit 1
      end

      stack.remove_paths(paths)

      say ''
      say "Removed #{paths.length} #{paths.length == 1 ? 'file' : 'files'}.", :green
      say ''
    end

    return if options[:'dry-run']

    exit 1 unless stack.install
  rescue => e
    say e.message, :red
    exit 1
  end

  desc 'version', 'Show Kaze version'
  def version
    puts Kaze::VERSION
  end

  private
    def ensure_rails_application
      return if File.exist?("#{Dir.pwd}/bin/rails")

      say 'Kaze must be run in a new Rails application.', :red
      exit 1
    end
end
