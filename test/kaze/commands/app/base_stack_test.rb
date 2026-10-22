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
end
