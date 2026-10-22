require 'test_helper'

# `kaze upgrade` deletes files from a real application, and it decides what to
# delete from each stack's REMOVED_PATHS. These keep that list honest.
class RemovedPathsTest < Kaze::TestCase
  STUB_ROOTS = {
    hotwire: [ 'hotwire', 'default' ],
    react: [ 'inertia-react-ts', 'inertia-common', 'default' ],
    vue: [ 'inertia-vue-ts', 'inertia-common', 'default' ]
  }.freeze

  def test_every_listed_path_is_one_the_stubs_no_longer_ship
    stacks.each do |stack, klass|
      klass::REMOVED_PATHS.each do |path|
        shipped = STUB_ROOTS.fetch(stack).find { |root| File.exist?("#{stubs_path}/#{root}/#{path}") }

        assert_nil shipped,
          "#{stack} lists #{path} for removal, but stubs/#{shipped} still ships it. " \
          'kaze upgrade would delete a file the install then puts back.'
      end
    end
  end

  def test_paths_are_relative_and_confined_to_the_application
    stacks.each do |stack, klass|
      klass::REMOVED_PATHS.each do |path|
        refute path.start_with?('/'), "#{stack} lists an absolute path: #{path}"
        refute_includes path, '..', "#{stack} lists a path that escapes the application: #{path}"
        assert path.start_with?('app/'), "#{stack} lists a path outside app/: #{path}"
      end
    end
  end

  def test_no_duplicates
    stacks.each do |stack, klass|
      paths = klass::REMOVED_PATHS

      assert_equal paths.uniq, paths, "#{stack} lists the same path twice"
    end
  end

  # The 1.x -> 2.x removals are what the command was built for, so they are
  # pinned: a path dropped from this list silently stops being cleaned up.
  def test_covers_the_files_dropped_between_1_4_0_and_2_0_0
    {
      hotwire: [
        'app/controllers/profile_controller.rb',
        'app/components/nav_link_component.rb',
        'app/views/layouts/_navigation.html.erb',
        'app/views/profile/edit.html.erb'
      ],
      react: [
        'app/controllers/password_controller.rb',
        'app/javascript/Components/PrimaryButton.tsx',
        'app/javascript/Pages/Profile/Edit.tsx'
      ],
      vue: [
        'app/javascript/Components/DropdownLink.vue',
        'app/javascript/Pages/Profile/Edit.vue'
      ]
    }.each do |stack, expected|
      expected.each do |path|
        assert_includes stacks.fetch(stack)::REMOVED_PATHS, path,
          "#{stack} no longer cleans up #{path}"
      end
    end
  end
end
