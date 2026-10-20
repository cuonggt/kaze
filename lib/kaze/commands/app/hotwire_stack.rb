class Kaze::Commands::App::HotwireStack < Kaze::Commands::App::BaseStack
  def install
    # Gems...
    return unless remove_gems([ 'sprockets-rails', 'stimulus-rails' ])
    return unless install_gems([ 'propshaft', 'view_component', 'turbo-rails', 'dotenv', 'bcrypt' ])
    return unless run_command("#{bundle_command} add tailwindcss-rails --version=\"~> 3.0\"").success?
    return unless install_gems([ 'hotwire-livereload' ], 'development')
    return unless install_gems([ 'factory_bot_rails', 'faker' ], 'development, test')

    # Controllers...
    FileUtils.copy_entry("#{stubs_path}/hotwire/app/controllers", "#{Dir.pwd}/app/controllers")

    # Models...
    FileUtils.copy_entry("#{stubs_path}/default/app/models", "#{Dir.pwd}/app/models")

    # Forms...
    ensure_directory_exists("#{Dir.pwd}/app/forms")
    FileUtils.copy_entry("#{stubs_path}/default/app/forms", "#{Dir.pwd}/app/forms")

    # Validators...
    ensure_directory_exists("#{Dir.pwd}/app/validators")
    FileUtils.copy_entry("#{stubs_path}/default/app/validators", "#{Dir.pwd}/app/validators")

    # Mailers...
    ensure_directory_exists("#{Dir.pwd}/app/mailers")
    FileUtils.copy_entry("#{stubs_path}/default/app/mailers", "#{Dir.pwd}/app/mailers")

    # Views...
    ensure_directory_exists("#{Dir.pwd}/app/views/layouts")
    ensure_directory_exists("#{Dir.pwd}/app/views/user_mailer")
    FileUtils.copy_entry("#{stubs_path}/hotwire/app/views", "#{Dir.pwd}/app/views")
    FileUtils.copy_file("#{stubs_path}/default/app/views/layouts/mailer.html.erb", "#{Dir.pwd}/app/views/layouts/mailer.html.erb")
    FileUtils.copy_file("#{stubs_path}/default/app/views/layouts/mailer.text.erb", "#{Dir.pwd}/app/views/layouts/mailer.text.erb")
    FileUtils.copy_entry("#{stubs_path}/default/app/views/user_mailer", "#{Dir.pwd}/app/views/user_mailer")

    # View Components + Alpine...
    ensure_directory_exists("#{Dir.pwd}/app/components")
    FileUtils.copy_entry("#{stubs_path}/hotwire/app/components", "#{Dir.pwd}/app/components")
    ensure_directory_exists("#{Dir.pwd}/app/javascript")
    FileUtils.copy_file("#{stubs_path}/hotwire/app/javascript/application.js", "#{Dir.pwd}/app/javascript/application.js")
    FileUtils.copy_file("#{stubs_path}/hotwire/app/javascript/alpinejs.stub", "#{Dir.pwd}/app/javascript/alpinejs.js")
    FileUtils.copy_file("#{stubs_path}/hotwire/config/importmap.rb", "#{Dir.pwd}/config/importmap.rb")

    # Tests...
    install_tests

    # Routes...
    FileUtils.copy_file("#{stubs_path}/default/config/routes.rb", "#{Dir.pwd}/config/routes.rb")

    # Migrations...
    install_migrations

    # Tailwind...
    FileUtils.copy_file("#{stubs_path}/default/app/assets/stylesheets/application.css", "#{Dir.pwd}/app/assets/stylesheets/application.css")
    FileUtils.copy_file("#{stubs_path}/default/app/assets/stylesheets/application.tailwind.css", "#{Dir.pwd}/app/assets/stylesheets/application.tailwind.css")
    FileUtils.copy_file("#{stubs_path}/hotwire/config/tailwind.config.js", "#{Dir.pwd}/config/tailwind.config.js")
    FileUtils.copy_file("#{stubs_path}/default/bin/dev", "#{Dir.pwd}/bin/dev")
    FileUtils.copy_file("#{stubs_path}/default/Procfile.dev", "#{Dir.pwd}/Procfile.dev")
    return unless run_command("#{Dir.pwd}/bin/rails tailwindcss:build").success?

    say ''
    say 'Kaze scaffolding installed successfully.', :green
  end
end
