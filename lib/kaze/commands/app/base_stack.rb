require 'bundler'
require 'fileutils'
require 'open3'

class Kaze::Commands::App::BaseStack
  def install
    raise NotImplementedError
  end

  # Paths from this stack's REMOVED_PATHS that the application still has. Only
  # ever a subset of that list: `kaze upgrade` never touches a path Kaze did not
  # put there itself.
  def removable_paths
    self.class::REMOVED_PATHS.select { |path| File.exist?("#{Dir.pwd}/#{path}") }
  end

  def remove_paths(paths)
    paths.each { |path| FileUtils.rm_f("#{Dir.pwd}/#{path}") }

    prune_empty_directories(paths)
  end

  private

  # Deleting the last file in a directory leaves the directory behind. Walk back
  # up from each one removing those that are now empty, and stop at the first
  # that is not -- a directory with anything left in it is the application's.
  def prune_empty_directories(paths)
    paths.map { |path| File.dirname("#{Dir.pwd}/#{path}") }.uniq.sort_by(&:length).reverse.each do |dir|
      while dir.start_with?("#{Dir.pwd}/app/") && Dir.exist?(dir) && Dir.empty?(dir)
        Dir.rmdir(dir)
        dir = File.dirname(dir)
      end
    end
  end

  def bundle_command
    @bundle_command ||= File.exist?("#{Dir.pwd}/bin/bundle") ? "#{Dir.pwd}/bin/bundle" : 'bundle'
  end

  # Bundler exports RUBYOPT and BUNDLE_* so that child processes join its
  # bundle. That is wrong for a nested bundler call: when kaze itself is run
  # through `bundle exec`, a `bundle add` it shells out to inherits them, and
  # any gem with a native extension fails to build, because extconf.rb loads
  # bundler/setup and tries to resolve a lockfile needing the very gem it is
  # about to compile. Shell out to bundler with that environment removed.
  def run_bundle_command(command)
    Bundler.with_unbundled_env { run_command(command) }
  end

  def install_gems(gems = [], group = nil)
    installed_gems = Bundler::Definition.build("#{Dir.pwd}/Gemfile", nil, {}).dependencies.map(&:name)

    gem_being_installed = gems.map { |gem| gem unless installed_gems.include?(gem) }.compact

    return true if gem_being_installed.empty?

    status = run_bundle_command("#{bundle_command} add #{gem_being_installed.join(" ")}#{group ? " --group \"#{group}\"" : ""}")

    status.success?
  end

  def remove_gems(gems = [])
    installed_gems = Bundler::Definition.build("#{Dir.pwd}/Gemfile", nil, {}).dependencies.map(&:name)

    gems_being_removed = gems.map { |gem| gem if installed_gems.include?(gem) }.compact

    return true if gems_being_removed.empty?

    status = run_bundle_command("#{bundle_command} remove #{gems_being_removed.join(" ")}")

    status.success?
  end

  def install_migrations
    stdin, _ = Open3.capture3("#{Dir.pwd}/bin/rails version")
    versions = stdin.gsub!('Rails ', '').split('.')
    railsVersion = [ versions[0], versions[1] ].join('.')

    ensure_directory_exists("#{Dir.pwd}/db/migrate")
    FileUtils.copy_entry("#{stubs_path}/default/db/migrate", "#{Dir.pwd}/db/migrate")
    Dir.children("#{Dir.pwd}/db/migrate").each { |file| replace_in_file(/ActiveRecord::Migration$/, "ActiveRecord::Migration[#{railsVersion}]", "#{Dir.pwd}/db/migrate/#{file}") }
  end

  def install_tests
    ensure_directory_exists("#{Dir.pwd}/test/factories")
    ensure_directory_exists("#{Dir.pwd}/test/integration")
    FileUtils.copy_file("#{stubs_path}/default/test/test_helper.rb", "#{Dir.pwd}/test/test_helper.rb")
    FileUtils.copy_entry("#{stubs_path}/default/test/factories", "#{Dir.pwd}/test/factories")
    FileUtils.copy_entry("#{stubs_path}/default/test/integration", "#{Dir.pwd}/test/integration")
  end

  def ensure_directory_exists(path)
    FileUtils.mkdir_p(path) unless File.directory?(path)
  end

  def replace_in_file(search, replace, path)
    File.write(path, File.read(path).gsub!(search, replace))
  end

  def run_command(command)
    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
      stdout.set_encoding(Encoding::UTF_8)
      stderr.set_encoding(Encoding::UTF_8)
      stdout_thread = Thread.new do
        while line = stdout.gets do
          say line.scrub
        end
      end
      stderr_thread = Thread.new do
        while line = stderr.gets do
          say line.scrub, :red
        end
      end
      stdout_thread.join
      stderr_thread.join
      wait_thr.value
    end
  end

  def run_commands(commands)
    commands.all? { |command| run_command(command).success? }
  end

  def say(message, color = nil)
    THOR.say(message, color)
  end

  def stubs_path
    "#{File.dirname(__FILE__)}/../../../../stubs"
  end
end
