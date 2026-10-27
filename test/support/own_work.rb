require 'fileutils'

# Work an application of its own would hold, in the same directories Kaze
# writes to. The gem's unit tests and the CI upgrade job both read it from
# here, so the two cannot drift apart.
#
# Every file is inert on purpose. The upgrade job seeds these into a real
# application that then boots, typechecks and runs its own tests, so a fixture
# that needed a column, a import or a JSX runtime would fail the job for
# reasons that have nothing to do with the upgrade.
module Kaze
  module OwnWork
    FILES = {
      'db/migrate/20260101000000_add_bio_to_users.rb' =>
        "class AddBioToUsers < ActiveRecord::Migration[8.1]\n" \
        "  def change\n    add_column :users, :bio, :text\n  end\nend\n",
      'db/migrate/20260102000000_create_posts.rb' =>
        "class CreatePosts < ActiveRecord::Migration[8.1]\n" \
        "  def change\n    create_table :posts\n  end\nend\n",
      'app/models/post.rb' => "class Post < ApplicationRecord\nend\n",
      # A .ts rather than a .tsx: both Inertia stacks typecheck
      # app/javascript/**/*.ts, while only React's tsconfig looks at .tsx.
      'app/javascript/lib/analytics.ts' => "export const analyticsKey = 'test'\n",
      'config/initializers/analytics.rb' => "Rails.application.config.analytics_key = ENV['ANALYTICS_KEY']\n",
      'test/factories/posts.rb' => "FactoryBot.define do\n  factory :post\nend\n",
      'test/models/post_test.rb' => "require 'test_helper'\n\nclass PostTest < ActiveSupport::TestCase\nend\n",
      'test/integration/dashboard_test.rb' =>
        "require 'test_helper'\n\nclass DashboardTest < ActionDispatch::IntegrationTest\nend\n"
    }.freeze

    def self.write(root = '.')
      FILES.each do |path, body|
        full = File.join(root, path)

        FileUtils.mkdir_p(File.dirname(full))
        File.write(full, body)
      end
    end

    # The paths that are no longer what the application left there, described
    # well enough to read in a CI log without opening anything.
    def self.damaged(root = '.')
      FILES.filter_map do |path, body|
        full = File.join(root, path)

        next "#{path}: gone" unless File.exist?(full)

        actual = File.read(full)

        next if actual == body

        "#{path}: #{body.bytesize} bytes became #{actual.bytesize}"
      end
    end
  end
end

# Called from the CI upgrade job, where there is no test suite to run this.
if $PROGRAM_NAME == __FILE__
  command, root = ARGV
  root ||= '.'

  case command
  when 'write'
    Kaze::OwnWork.write(root)
    puts "Wrote #{Kaze::OwnWork::FILES.length} files of the application's own."
  when 'verify'
    damaged = Kaze::OwnWork.damaged(root)

    if damaged.empty?
      puts "All #{Kaze::OwnWork::FILES.length} files of the application's own came through untouched."
    else
      warn "The upgrade changed files that were not Kaze's:"
      damaged.each { |line| warn "  #{line}" }
      exit 1
    end
  else
    abort 'Usage: own_work.rb {write|verify} [dir]'
  end
end
