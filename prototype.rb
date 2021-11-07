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
gem 'graphql'
gem 'graphql-batch'
gem 'graphiql-rails'
gem 'activeadmin'
gem 'sidekiq'
gem 'active_interaction'
# TODO AUDITED
# gem 'audited'
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

run "cp -r #{File.join(source_paths.first, 'vendor/zuul')} #{File.join(destination_root, 'vendor/zuul')}"
run "cp -r #{File.join(source_paths.first, 'vendor/greenhill')} #{File.join(destination_root, 'vendor/greenhill')}"

commit "adds default gems to Gemfile (and vendors greenhill/zuul for now)"


#
# Setup and launch Postgres and Redis via docker-compose
#
## TODO make the docker compose template able to handle different databases (postgres, mysql, none/sqlite)
template 'docker-compose.yml'
run "docker-compose up -d"

# configure app for docker postgres
remove_file 'config/database.yml'
template 'config/databases/postgresql.yml', 'config/database.yml'

commit "runs supporting services via docker-compose in development"

# configure active_record to use UUIDs by default for primary keys and enable the extension in postgres
template 'db/migrate/enable_extensions.rb', "db/migrate/#{DateTime.now.strftime '%Y%m%d%H%M%S'}_enable_extensions.rb"
template 'config/initializers/active_record.rb'

commit "enables postgres extensions and configures activerecord to use UUIDs for primary keys"


#
# Additional configuration, templates, etc.
#
environment "config.action_mailer.default_url_options = { host: 'localhost', port: ENV.fetch('PORT', 3000) }", env: 'development'
template 'lib/tasks/auto_annotate_models.rake'
# TODO AUDITED
# template 'config/initializers/audited.rb'
template 'Procfile'
template '.env' # TODO break out ENV vars into their relevant generators with append_to_file
template '.env', '.env.example'
append_to_file '.gitignore', '.env'

commit "performs some additional configuration"

# copy default application interaction
template 'app/interactions/application_interaction.rb'
commit "adds a default application interaction"


after_bundle do
  commit "bundles and prepares application"

  generate 'rspec:install'
  commit "runs rspec install generator"

  generate 'greenhill:sidekiq:install'
  commit "runs greenhill sidekiq install generator"

  generate 'greenhill:devise:install'
  commit "runs greenhill devise install generator"

  generate 'greenhill:pundit:install'
  commit "runs greenhill pundit install generator"

  generate 'greenhill:graphql:install'
  commit "runs greenhill graphql install generator"

  generate "zuul:install #{app_name}"
  commit "runs zuul install generator"
  
  generate "greenhill:admin:install #{webpack_install? ? '--use-webpacker' : ''}"
  commit "runs greenhill active_admin install generator"

  # TODO AUDITED
  # generate 'audited:install --audited-user-id-column-type uuid --audited-changes-column-type jsonb'

  # TODO typescript, react, styled*, apollo, etc.

  generate 'greenhill:user User'
  # TODO specs / factories
  # TODO AUDITED
  # inject_into_file 'app/models/user.rb', "\n\n  audited",
  #   after: 'jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null'
  commit "generates user model & admin resource, and a development seed account"

  # initialize the application database
  rails_command "db:create db:migrate db:seed", abort_on_failure: true
  commit "initializes database"

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