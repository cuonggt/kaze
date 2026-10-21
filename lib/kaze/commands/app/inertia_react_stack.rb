class Kaze::Commands::App::InertiaReactStack < Kaze::Commands::App::BaseStack
  def install
    # Gems...
    return unless remove_gems([ 'sprockets-rails', 'turbo-rails', 'stimulus-rails' ])
    return unless install_gems([ 'propshaft', 'inertia_rails', 'vite_rails', 'dotenv', 'bcrypt', 'js-routes' ])
    return unless run_command("#{bundle_command} add tailwindcss-rails --version=\"~> 4.0\"").success?
    return unless install_gems([ 'factory_bot_rails', 'faker' ], 'development, test')

    # NPM Packages...
    FileUtils.copy_file("#{stubs_path}/inertia-react-ts/package.json", "#{Dir.pwd}/package.json")

    # Controllers...
    FileUtils.copy_entry("#{stubs_path}/inertia-common/app/controllers", "#{Dir.pwd}/app/controllers")

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
    FileUtils.copy_file("#{stubs_path}/inertia-react-ts/app/views/layouts/application.html.erb", "#{Dir.pwd}/app/views/layouts/application.html.erb")
    FileUtils.copy_file("#{stubs_path}/default/app/views/layouts/mailer.html.erb", "#{Dir.pwd}/app/views/layouts/mailer.html.erb")
    FileUtils.copy_file("#{stubs_path}/default/app/views/layouts/mailer.text.erb", "#{Dir.pwd}/app/views/layouts/mailer.text.erb")
    FileUtils.copy_entry("#{stubs_path}/default/app/views/user_mailer", "#{Dir.pwd}/app/views/user_mailer")

    # Components + Pages...
    ensure_directory_exists("#{Dir.pwd}/app/javascript")
    FileUtils.copy_entry("#{stubs_path}/inertia-react-ts/app/javascript", "#{Dir.pwd}/app/javascript")

    # Tests...
    install_tests
    FileUtils.copy_entry("#{stubs_path}/inertia-common/test/integration", "#{Dir.pwd}/test/integration")

    # Routes...
    FileUtils.copy_file("#{stubs_path}/default/config/routes.rb", "#{Dir.pwd}/config/routes.rb")

    # Migrations...
    install_migrations

    # Tailwind / Vite...
    FileUtils.copy_file("#{stubs_path}/default/app/assets/stylesheets/application.css", "#{Dir.pwd}/app/assets/stylesheets/application.css")
    ensure_directory_exists("#{Dir.pwd}/app/assets/tailwind")
    FileUtils.copy_file("#{stubs_path}/inertia-react-ts/app/assets/tailwind/application.css", "#{Dir.pwd}/app/assets/tailwind/application.css")
    FileUtils.copy_file("#{stubs_path}/inertia-common/config/vite.json", "#{Dir.pwd}/config/vite.json")
    FileUtils.copy_file("#{stubs_path}/inertia-react-ts/tsconfig.json", "#{Dir.pwd}/tsconfig.json")
    FileUtils.copy_file("#{stubs_path}/inertia-react-ts/vite.config.ts", "#{Dir.pwd}/vite.config.ts")
    FileUtils.copy_file("#{stubs_path}/default/bin/dev", "#{Dir.pwd}/bin/dev")
    FileUtils.copy_file("#{stubs_path}/inertia-common/bin/vite", "#{Dir.pwd}/bin/vite")
    FileUtils.copy_file("#{stubs_path}/default/Procfile.dev", "#{Dir.pwd}/Procfile.dev")
    replace_in_file('#vite: bin/vite dev', 'vite: bin/vite dev', "#{Dir.pwd}/Procfile.dev")
    run_command("#{Dir.pwd}/bin/rails generate js_routes:middleware")
    return unless run_command("#{Dir.pwd}/bin/rails tailwindcss:build").success?

    say ''
    say 'Installing and building Node dependencies.', :magenta

    node_dependencies_installed =
      if File.exist?("#{Dir.pwd}/pnpm-lock.yaml")
        run_commands([ 'pnpm install', 'pnpm run build' ])
      elsif File.exist?("#{Dir.pwd}/yarn.lock")
        run_commands([ 'yarn install', 'yarn build' ])
      elsif File.exist?("#{Dir.pwd}/bun.lock") || File.exist?("#{Dir.pwd}/bun.lockb")
        run_commands([ 'bun install', 'bun run build' ])
      else
        run_commands([ 'npm install', 'npm run build' ])
      end

    return unless node_dependencies_installed

    say ''
    say 'Kaze scaffolding installed successfully.', :green
  end
end
