require 'test_helper'

class VersionTest < Kaze::TestCase
  def test_is_a_release_version
    assert_match(/\A\d+\.\d+\.\d+\z/, Kaze::VERSION)
  end

  # The gemspec reads lib/kaze/version.rb, so a mismatch here means the built
  # gem would carry a version the changelog does not describe.
  def test_matches_the_newest_changelog_entry
    changelog = File.read(File.expand_path('../../CHANGELOG.md', __dir__), encoding: 'UTF-8')
    newest = changelog[/^## \[(\d+\.\d+\.\d+)\]/, 1]

    assert_equal newest, Kaze::VERSION,
      "lib/kaze/version.rb is #{Kaze::VERSION} but the newest changelog entry is #{newest}"
  end
end
