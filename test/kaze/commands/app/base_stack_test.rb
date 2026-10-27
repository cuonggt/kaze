require 'test_helper'

class BaseStackTest < Kaze::TestCase
  class FakeStack < Kaze::Commands::App::BaseStack
    REMOVED_PATHS = [
      'app/javascript/Components/Gone.tsx',
      'app/javascript/Pages/Profile/Edit.tsx',
      'app/javascript/Pages/Profile/Partials/Old.tsx'
    ].freeze
  end

  def setup
    @stack = FakeStack.new
  end

  def test_removable_paths_lists_only_what_the_application_has
    in_app([ 'app/javascript/Components/Gone.tsx' ]) do
      assert_equal [ 'app/javascript/Components/Gone.tsx' ], @stack.removable_paths
    end
  end

  def test_removable_paths_is_empty_when_nothing_is_left_over
    in_app([ 'app/javascript/Components/Mine.tsx' ]) do
      assert_empty @stack.removable_paths
    end
  end

  def test_remove_paths_deletes_the_listed_files
    in_app(FakeStack::REMOVED_PATHS) do |dir|
      @stack.remove_paths(@stack.removable_paths)

      FakeStack::REMOVED_PATHS.each { |path| refute_path_exists "#{dir}/#{path}" }
    end
  end

  def test_remove_paths_leaves_files_it_was_not_given
    in_app(FakeStack::REMOVED_PATHS + [ 'app/javascript/Components/Mine.tsx' ]) do |dir|
      @stack.remove_paths(@stack.removable_paths)

      assert_path_exists "#{dir}/app/javascript/Components/Mine.tsx"
    end
  end

  def test_remove_paths_prunes_directories_it_empties
    in_app(FakeStack::REMOVED_PATHS) do |dir|
      @stack.remove_paths(@stack.removable_paths)

      refute_path_exists "#{dir}/app/javascript/Pages/Profile/Partials"
      refute_path_exists "#{dir}/app/javascript/Pages/Profile"
    end
  end

  # The property the command rests on: someone's own work living beside Kaze's
  # keeps both the file and the directory holding it.
  def test_remove_paths_keeps_directories_that_still_hold_other_files
    in_app(FakeStack::REMOVED_PATHS + [ 'app/javascript/Pages/Profile/Mine.tsx' ]) do |dir|
      @stack.remove_paths(@stack.removable_paths)

      assert_path_exists "#{dir}/app/javascript/Pages/Profile/Mine.tsx"
      assert_path_exists "#{dir}/app/javascript/Pages/Profile"
      refute_path_exists "#{dir}/app/javascript/Pages/Profile/Partials"
    end
  end

  def test_remove_paths_never_prunes_above_app
    in_app(FakeStack::REMOVED_PATHS) do |dir|
      @stack.remove_paths(@stack.removable_paths)

      assert_path_exists "#{dir}/app"
    end
  end

  def test_remove_paths_tolerates_a_missing_file
    in_app([ 'app/javascript/Components/Gone.tsx' ]) do
      @stack.remove_paths(FakeStack::REMOVED_PATHS)
    end
  end

  def test_install_is_not_implemented_on_the_base
    assert_raises(NotImplementedError) { Kaze::Commands::App::BaseStack.new.install }
  end

  # `gsub!` returns nil when it matched nothing, and writing that back emptied
  # the file. Every call site passes a pattern that may legitimately be absent
  # -- already applied by an earlier install, or edited out by the application
  # -- so missing has to mean leave it alone.
  def test_replace_in_file_leaves_a_file_alone_when_nothing_matches
    in_app do |dir|
      path = "#{dir}/config/environments/test.rb"
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, "Rails.application.configure do\nend\n")

      @stack.send(:replace_in_file, /^  config\.cache_store = :null_store$/, '  config.cache_store = :memory_store', path)

      assert_equal "Rails.application.configure do\nend\n", File.read(path)
    end
  end

  def test_replace_in_file_substitutes_when_it_matches
    in_app do |dir|
      path = "#{dir}/Procfile.dev"
      File.write(path, "#vite: bin/vite dev\n")

      @stack.send(:replace_in_file, '#vite: bin/vite dev', 'vite: bin/vite dev', path)

      assert_equal "vite: bin/vite dev\n", File.read(path)
    end
  end

  # The rewrite used to walk the whole of db/migrate, where the pattern only
  # fits the migrations Kaze ships -- an application's own already carry a
  # version suffix, so they matched nothing and were emptied.
  def test_install_migrations_leaves_the_applications_own_work_alone
    in_app_with_own_work do |dir|
      fake_rails(dir)

      @stack.send(:install_migrations)

      assert_own_work_untouched(dir)
    end
  end

  def test_install_migrations_writes_the_rails_version_into_the_ones_it_ships
    in_app_with_own_work do |dir|
      fake_rails(dir)

      @stack.send(:install_migrations)

      Dir.children("#{stubs_path}/default/db/migrate").each do |file|
        migration = File.read("#{dir}/db/migrate/#{file}")

        assert_includes migration, 'ActiveRecord::Migration[8.1]', "#{file} did not get the version written into it"
      end
    end
  end

  # Kaze copies its own tests in beside whatever is already there.
  def test_install_tests_leaves_the_applications_own_work_alone
    in_app_with_own_work do |dir|
      @stack.send(:install_tests)

      assert_own_work_untouched(dir)
    end
  end

  def test_install_tests_installs_the_ones_it_ships
    in_app_with_own_work do |dir|
      @stack.send(:install_tests)

      assert_path_exists "#{dir}/test/test_helper.rb"
      assert_path_exists "#{dir}/test/models/two_factor_authenticatable_test.rb"
      assert_path_exists "#{dir}/test/integration/auth/authentication_test.rb"
    end
  end

  def test_enable_test_cache_store_leaves_the_applications_own_work_alone
    in_app_with_own_work do |dir|
      write_test_environment(dir)

      @stack.send(:enable_test_cache_store)

      assert_own_work_untouched(dir)
    end
  end

  def test_enable_test_cache_store_changes_only_the_cache_store_line
    in_app_with_own_work do |dir|
      path = write_test_environment(dir)

      @stack.send(:enable_test_cache_store)

      assert_equal TEST_ENVIRONMENT.sub(':null_store', ':memory_store'), File.read(path)
    end
  end

  # Running an install twice is ordinary -- `kaze upgrade` is an install, and so
  # is re-running `kaze install`. The second pass found no :null_store left to
  # match and emptied the file.
  def test_enable_test_cache_store_is_safe_to_run_twice
    in_app_with_own_work do |dir|
      path = write_test_environment(dir)

      2.times { @stack.send(:enable_test_cache_store) }

      assert_equal TEST_ENVIRONMENT.sub(':null_store', ':memory_store'), File.read(path)
      assert_own_work_untouched(dir)
    end
  end

  def test_enable_test_cache_store_tolerates_a_missing_file
    in_app_with_own_work do |dir|
      @stack.send(:enable_test_cache_store)

      assert_own_work_untouched(dir)
    end
  end

  # The upgrade side: what it offers to delete is Kaze's, never the
  # application's, however alike the two look.
  def test_removable_paths_never_lists_the_applications_own_work
    in_app_with_own_work(FakeStack::REMOVED_PATHS) do
      assert_equal FakeStack::REMOVED_PATHS.sort, @stack.removable_paths.sort
    end
  end

  def test_remove_paths_leaves_the_applications_own_work_alone
    in_app_with_own_work(FakeStack::REMOVED_PATHS) do |dir|
      @stack.remove_paths(@stack.removable_paths)

      assert_own_work_untouched(dir)
    end
  end

  private
    def write_test_environment(dir)
      path = "#{dir}/config/environments/test.rb"
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, TEST_ENVIRONMENT)

      path
    end
end
