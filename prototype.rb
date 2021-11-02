require 'byebug'

TEMPLATE_PATH = File.expand_path(File.dirname(__FILE__))
def source_paths
  [TEMPLATE_PATH]
end

def commit(message)
  git add: "."
  git commit: %Q{ -m '#{message.gsub(/'/, "\'")}' }
end

####
# TODO
# - break up each coherent bit into separate little chunks (i.e. auth: users/devise/pundit/jwt, admin: activeadmin, jobs: sidekiq, etc.)
#   - move into lib/generators
#   - break up sub-groups (i.e. separate devise/pundit/jwt)
#   - move into /lib/generators/
#   - MAYBE create actual generators for a lot of these chunks? could have a simple template, which would call the additional generators... i.e. /lib/generators/database.rb + /lib/generators/database/generator.rb + /lib/generators/database/templates/*
#   - git commit along the way, to highlight each step
#
# - /templates/ directory
#   - also templates/ subdirs for generators above (i.e. /lib/generators/users/devise/config/initializers/devise.rb)
#
# - generic & basic layouts for rails views (and eventually SPA)
#   - include flash messages
#   - add a default homepage with instructions?
#   - still use components?? maybe "react-rails"?? allows for (potentially) re-using the same UI across rails views and the SPA... would have to account for context/theming, etc. though
#
# - fill out stuff like specs, factories, types, etc. (for included stuff like users)
#
# - integrate graphql types w/ typescript via codegen (once frontend stuff is fleshed out)
#
# - 
#
# - various security stuff
#   - lock down jwt cookie
#   - check additional security attrs in jwt.rb
#   - cors (especially for potential subdomain/multi-tenant stuff)
####


commit "initializes new rails app #{app_name}"


#
# Add default starter gems
#
gem 'devise'
gem 'devise-jwt'
gem 'pundit'
gem 'activeadmin'
gem 'sidekiq'
gem 'active_interaction'
gem 'graphql'
gem 'graphiql-rails'
# TODO logging (structured, lograge, etc.)
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


commit "adds default starter gems to Gemfile"


#
# Setup and launch Postgres and Redis via docker-compose
#
template 'docker-compose.yml'
run "docker-compose up -d"

# configure app for docker postgres
remove_file 'config/database.yml'
template 'config/databases/postgresql.yml', 'config/database.yml'

commit "runs postgres and redis via docker-compose"

# configure active_record to use UUIDs by default for primary keys and enable the extension in postgres
template 'db/migrate/enable_extensions.rb', "db/migrate/#{DateTime.now.strftime '%Y%m%d%H%M%S'}_enable_extensions.rb"
template 'config/initializers/active_record.rb'

commit "enables postgres extensions and configures activerecord to use UUIDs for primary keys"




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

commit "performs some additional configuration"




after_bundle do
  commit "bundles and prepares application"


  # run additional generators, installers, etc.
  generate 'rspec:install'
  generate 'devise:install'
  generate 'pundit:install'
  generate 'graphql:install'
  generate "active_admin:install --skip-users #{webpack_install? ? '--use-webpacker' : ''}"
  route <<-ROUTE
  authenticate :user, ->(user) { user.admin? } do
    mount GraphiQL::Rails::Engine, at: '/admin/graphiql', graphql_path: '/graphql'
  end
ROUTE

  commit "runs install generators for relevant gems"



  # configure devise-jwt secret
  devise_jwt = <<-DEVISE_JWT
  # ==> Configure JWT for :jwt_authenticatable
  config.jwt do |jwt|
    jwt.secret = ENV.fetch('JWT_SECRET')
  end

DEVISE_JWT
  inject_into_file 'config/initializers/devise.rb', devise_jwt, before: "  # ==> Controller configuration"

  commit "configures devise to work with JWT"



  # configure sidekiq web UI admin routes
  prepend_to_file 'config/routes.rb', "require 'sidekiq/web'\n"
  route <<-ROUTE
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end
ROUTE

  commit "configures sidekiq web UI admin routes"

  # TODO typescript, react, styled*, apollo, etc.



  # setup and generate users
  generate 'devise User'
  generate 'migration add_admin_to_users admin:boolean'
  template 'app/admin/user.rb'
  append_to_file 'db/seeds.rb',
    "User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true) if Rails.env.development?"

  inject_into_file 'app/models/user.rb', ",\n         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null",
    after: ':recoverable, :rememberable, :validatable'

  commit "generates user model, admin resource, and a development seed account"


  # copy default application interaction
  template 'app/interactions/application_interaction.rb'

  commit "adds a default application interaction"



  # copy default pundit policies
  template 'app/policies/authenticated_policy.rb'
  template 'app/policies/admin_policy.rb'
  template 'app/policies/public_policy.rb'
  template 'app/policies/user_policy.rb'
  template 'app/policies/admin/user_policy.rb'

  commit "adds some initial pundit policies"



  # reconfigure active_admin
  remove_file 'config/initializers/active_admin.rb'
  template 'config/initializers/active_admin.rb'

  commit "configures activeadmin to work with devise + pundit"



  # configure simplecov to work with rspec
  prepend_to_file 'spec/spec_helper.rb', <<-COVERAGE
# Load and launch SimpleCov at the very top of your spec_helper.rb
# SimpleCov.start must be issued before any of your application code is required
# See https://github.com/simplecov-ruby/simplecov#getting-started
require 'simplecov'
SimpleCov.start\n
COVERAGE

  commit "integrates simplecov with rspec"

  #
  # Initialize the application database
  #
  rails_command "db:create db:migrate db:seed", abort_on_failure: true

  commit "initializes database"
end