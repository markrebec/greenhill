TEMPLATE_PATH = File.expand_path(File.dirname(__FILE__))
def source_paths
  [TEMPLATE_PATH]
end

#
# Setup and launch Postgres via Docker/Compose
#
template 'docker-compose.yml'
run "docker-compose up -d"

# configure postgres for docker
remove_file 'config/database.yml'
template 'config/databases/postgresql.yml', 'config/database.yml'

#
# Add default starter gems
#
gem 'devise'
gem 'pundit'
gem 'activeadmin'
# graphql
# interactions
# sidekiq (redis/docker)
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

#
# Additional configuration, tasks, etc.
#
environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: 'development'
template 'lib/tasks/auto_annotate_models.rake'






after_bundle do
  puts <<-BANNER
####################
# 1ST AFTER BUNDLE #
####################
BANNER
  
  #
  # Run additional generators, installers, etc.
  #
  generate 'rspec:install'
  generate 'devise:install'
  generate 'pundit:install'
  generate "active_admin:install --skip-users #{webpack_install? ? '--use-webpacker' : ''}"

  # TODO typescript, react, styled*, apollo, etc.

  # setup and generate users
  generate 'devise User'
  generate 'migration add_admin_to_users admin:boolean'
  template 'app/admin/user.rb'
  append_to_file 'db/seeds.rb',
    "User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true) if Rails.env.development?"

  # create default pundit policies
  template 'app/policies/authenticated_policy.rb'
  template 'app/policies/admin_policy.rb'
  template 'app/policies/public_policy.rb'
  template 'app/policies/user_policy.rb'
  template 'app/policies/admin/user_policy.rb'
  template 'app/policies/active_admin/page_policy.rb'
  template 'app/policies/active_admin/comment_policy.rb'

  # TODO use inject_into_file instead?
  # configure active_admin to use pundit
  gsub_file 'config/initializers/active_admin.rb',
    /# config\.authorization_adapter = ActiveAdmin::CanCanAdapter/,
    'config.authorization_adapter = ActiveAdmin::PunditAdapter'

  gsub_file 'config/initializers/active_admin.rb',
    /# config\.pundit_default_policy = "MyDefaultPunditPolicy"/,
    'config.pundit_default_policy = "AdminPolicy"'

  gsub_file 'config/initializers/active_admin.rb',
    /# config\.pundit_policy_namespace = :admin/,
    'config.pundit_policy_namespace = :admin'



  gsub_file 'config/initializers/active_admin.rb',
    /config\.logout_link_path = :destroy_admin_user_session_path/,
    'config.logout_link_path = :destroy_user_session_path'

  gsub_file 'config/initializers/active_admin.rb',
    /# config\.current_user_method = :current_admin_user/,
    'config.current_user_method = :current_user'

  gsub_file 'config/initializers/active_admin.rb',
    /# config\.authentication_method = :authenticate_admin_user!/,
    'config.authentication_method = :authenticate_user!'

  

  prepend_to_file 'spec/spec_helper.rb', <<-SCOV
# Load and launch SimpleCov at the very top of your spec_helper.rb
# SimpleCov.start must be issued before any of your application code is required
# See https://github.com/simplecov-ruby/simplecov#getting-started
require 'simplecov'
SimpleCov.start\n
SCOV


  #
  # Setup the application database
  #
  rails_command("db:create db:migrate db:seed", abort_on_failure: true)

  #
  # Commit initial app repo
  #
  git add: "."
  git commit: %Q{ -m 'Initial commit of #{app_name}' }
end

after_bundle do
  puts <<-BANNER
####################
# 2ND AFTER BUNDLE #
####################
BANNER
end