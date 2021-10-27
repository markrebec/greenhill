TEMPLATE_PATH = File.expand_path(File.dirname(__FILE__))
def source_paths
  [TEMPLATE_PATH]
end

#
# Setup and launch Postgres and Redis via docker-compose
#
template 'docker-compose.yml'
run "docker-compose up -d"

# configure app for docker postgres
remove_file 'config/database.yml'
template 'config/databases/postgresql.yml', 'config/database.yml'

#
# Add default starter gems
#
gem 'devise'
gem 'pundit'
gem 'activeadmin'
gem 'sidekiq'
# graphql
# interactions
# logging
gem_group :development, :test do
  gem 'amazing_print'
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'simplecov', require: false
end
gem_group :development do
  gem 'solargraph'
  gem 'annotate'
end

gsub_file 'Gemfile',
  /gem 'tzinfo-data'/,
  "# gem 'tzinfo-data'"

#
# Additional configuration, templates, etc.
#
environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: 'development'
template 'lib/tasks/auto_annotate_models.rake'

environment 'config.active_job.queue_adapter = :sidekiq'
template 'config/initializers/sidekiq.rb'
template 'config/sidekiq.yml'

template 'Procfile'
template '.env'
template '.env', '.env.example'
append_to_file '.gitignore', '.env'






after_bundle do
  #
  # Run additional generators, installers, etc.
  #
  generate 'rspec:install'
  generate 'devise:install'
  generate 'pundit:install'
  generate "active_admin:install --skip-users #{webpack_install? ? '--use-webpacker' : ''}"

  # configure sidekiq web ui routes
  sidekiq_route = <<-ROUTE
\n  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end
ROUTE
  prepend_to_file 'config/routes.rb', "require 'sidekiq/web'\n"
  inject_into_file 'config/routes.rb', sidekiq_route, after: 'ActiveAdmin.routes(self)'

  # TODO typescript, react, styled*, apollo, etc.

  # setup and generate users
  generate 'devise User'
  generate 'migration add_admin_to_users admin:boolean'
  template 'app/admin/user.rb'
  append_to_file 'db/seeds.rb',
    "User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true) if Rails.env.development?"


  # copy default pundit policies
  template 'app/policies/authenticated_policy.rb'
  template 'app/policies/admin_policy.rb'
  template 'app/policies/public_policy.rb'
  template 'app/policies/user_policy.rb'
  template 'app/policies/admin/user_policy.rb'

  # reconfigure active_admin
  remove_file 'config/initializers/active_admin.rb'
  template 'config/initializers/active_admin.rb'

  # configure simplecov to work with rspec
  prepend_to_file 'spec/spec_helper.rb', <<-SCOV
# Load and launch SimpleCov at the very top of your spec_helper.rb
# SimpleCov.start must be issued before any of your application code is required
# See https://github.com/simplecov-ruby/simplecov#getting-started
require 'simplecov'
SimpleCov.start\n
SCOV


  #
  # Initialize the application database
  #
  rails_command "db:create db:migrate db:seed", abort_on_failure: true

  #
  # Commit initial app repo
  #
  git add: "."
  git commit: %Q{ -m 'Initial commit of #{app_name}' }
end

# after_bundle do
#   puts <<-BANNER
# ####################
# # 2ND AFTER BUNDLE #
# ####################
# BANNER
# end