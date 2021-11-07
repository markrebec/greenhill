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
# - 
#
# - various security stuff
#   - lock down jwt cookie
#   - check additional security attrs in jwt.rb
#   - cors (especially for potential subdomain/multi-tenant stuff)
#
#
#
##################################
#
# - break out zuul, write tests
#
# - integrate graphql types w/ typescript via codegen (once frontend stuff is fleshed out)
#
# - audits
#
#############################
#
# - custom generators (graphql type, admin resource [HOOKS hook_for]), scaffolds (skip stylesheets, javascript, controller, etc.), etc.
# - handle flags (i.e. skip postgres, skip rspec)... OR MAYBE enforce those flags by default (if possible)?
#
# ON MODEL: generate policy, generate type
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
# TODO AUDITED
# gem 'audited'
gem 'graphql'
gem 'graphql-batch'
gem 'graphiql-rails'
gem 'zuul', path: './vendor/zuul'
gem 'greenhill', path: './vendor/greenhill'
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

gsub_file 'Gemfile', /gem 'tzinfo-data'/, "# gem 'tzinfo-data'"

directory 'vendor/zuul'
directory 'vendor/greenhill'

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
# TODO AUDITED
# template 'config/initializers/audited.rb'

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
  commit "runs rspec install generator"

  generate 'devise:install'
  commit "runs devise install generator"

  generate 'pundit:install'
  commit "runs pundit install generator"

  generate 'graphql:install'
  commit "runs graphql install generator"

  generate "zuul:install #{app_name}"
  commit "runs zuul install generator"

  # TODO AUDITED
  # generate 'audited:install --audited-user-id-column-type uuid --audited-changes-column-type jsonb'

  generate "active_admin:install --skip-users #{webpack_install? ? '--use-webpacker' : ''}"
  commit "runs active_admin install generator"

  prepend_to_file 'config/routes.rb', "require 'sidekiq/web'\n"
  route <<-ROUTE
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
    mount GraphiQL::Rails::Engine, at: '/admin/graphiql', graphql_path: '/graphql'
  end
ROUTE
  commit "mounts graphiql and sidekiq within the admin namespace wrapped in auth"

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



  # TODO try installing graphql with the batch flag instead of doing this manually
  # configure graphql-batch loaders
  prepend_to_file "app/graphql/#{app_name.underscore}_schema.rb", "require 'graphql/batch'\n\n"
  inject_into_file "app/graphql/#{app_name.underscore}_schema.rb",
    "\n  use GraphQL::Batch",
    after: "query(Types::QueryType)"

  template 'app/graphql/record_loader.rb'
  template 'app/graphql/association_loader.rb'

  commit "configures graphql with graphql-batch and basic batch loaders"
  



  # configure devise-jwt secret
  inject_into_file 'config/initializers/devise.rb',
  before: "  # ==> Controller configuration\n" do <<-DEVISE
    # ==> Configure JWT for :jwt_authenticatable
    config.jwt do |jwt|
      jwt.secret = ENV.fetch('JWT_SECRET')
    end  
DEVISE
  end
  commit "configures devise JWT secret via env vars"


  gsub_file 'app/controllers/graphql_controller.rb',
    /# current_user: current_user/,
    'current_user: current_user'
  commit "configures graphql context with devise current_user"



  # TODO typescript, react, styled*, apollo, etc.



  # setup and generate users
  generate 'devise User'
  generate 'migration add_admin_to_users admin:boolean'
  template 'app/admin/users.rb'
  append_to_file 'db/seeds.rb',
    "User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true) if Rails.env.development?"

  inject_into_file 'app/models/user.rb',
    ",\n         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null",
    after: ":recoverable, :rememberable, :validatable"
  # TODO AUDITED
  # inject_into_file 'app/models/user.rb', "\n\n  audited",
  #   after: 'jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null'

  # TODO specs / factories
  commit "generates user model & admin resource, and a development seed account"



  # initialize the application database
  rails_command "db:create db:migrate db:seed", abort_on_failure: true
  commit "initializes database"




  # generate user type for graphql
  generate 'graphql:object User'
  inject_into_file "app/graphql/types/user_type.rb",
    "\n    pundit_role :admin",
    after: "class UserType < Types::BaseObject"
  commit "generates basic user type for graphql"



  # configure simplecov to work with rspec
  prepend_to_file 'spec/spec_helper.rb', <<-COVERAGE
# Load and launch SimpleCov at the very top of your spec_helper.rb
# SimpleCov.start must be issued before any of your application code is required
# See https://github.com/simplecov-ruby/simplecov#getting-started
require 'simplecov'
SimpleCov.start\n
COVERAGE

  commit "integrates simplecov with rspec"
end