require 'byebug'

TEMPLATE_PATH = File.join(File.expand_path(File.dirname(__FILE__)), 'templates')
def source_paths
  [TEMPLATE_PATH]
end

def commit(message)
  git add: "."
  git commit: %Q{ -m '#{message.gsub(/'/, "\'")}' }
end

####
# TODO
#
# - generic & basic layouts for rails views (and eventually SPA)
#   - include flash messages
#   - add a default homepage with instructions?
#   - override devise views
#   - still use components?? maybe "react-rails"?? allows for (potentially) re-using the same UI across rails views and the SPA... would have to account for context/theming, etc. though
#
# - fill out stuff like specs, factories, types, etc. (for included stuff like users)
#
# - various security stuff
#   - cors (especially for potential subdomain/multi-tenant stuff)
#
##################################
#
# - audits / analytics / experiments / logging
#
#############################
#
# - handle more generator flags (i.e. skip postgres, skip rspec)... OR MAYBE enforce those flags by default (if possible)?
#
####


commit "initializes new rails app #{app_name}"

if options[:database] != 'postgresql'
  # TODO better command help/args/recommendations
  say "Greenhill assumes you'll be using postgresql"
  exit!
end

if options[:webpack] != 'react' || options[:skip_webpack_install] == true
  # TODO better command help/args/recommendations
  say "Greenhill assumes you'll be using react via webpack"
  exit!
end

if options[:skip_test] != true
    # TODO better command help/args/recommendations
    yes_no = ask "You have opted to install Test::Unit.\nGreenhill recommends RSpec, and will be installing and configuring it. Are you sure you'd like to continue? [Y/n]"
    if yes_no.downcase.in?(['n', 'no'])
      exit!
    end
end



# add default starter gems
gem 'devise'
gem 'devise-jwt'
gem 'pundit'
gem 'graphql'
gem 'graphql-batch'
gem 'graphiql-rails'
gem 'activeadmin'
gem 'sidekiq'
gem 'active_interaction'
# TODO logging (structured, lograge, etc.), auditing, analytics

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

run 'mkdir vendor/greenhill'
run "cp #{File.join(File.expand_path(File.dirname(__FILE__)), 'greenhill.gemspec')} #{File.join(destination_root, 'vendor/greenhill/greenhill.gemspec')}"
run "cp -r #{File.join(File.expand_path(File.dirname(__FILE__)), 'lib')} #{File.join(destination_root, 'vendor/greenhill/lib')}"
run "cp -r #{File.join(File.expand_path(File.dirname(__FILE__)), 'vendor/zuul')} #{File.join(destination_root, 'vendor/zuul')}"

gem 'zuul', path: './vendor/zuul'
gem 'greenhill', path: './vendor/greenhill'

commit "adds default gems to Gemfile (and vendors greenhill/zuul for now)"


##############################################################################################################


# setup and launch Postgres and Redis via docker-compose
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


##############################################################################################################


# additional configuration, templates, etc.
environment "config.action_mailer.default_url_options = { host: 'localhost', port: ENV.fetch('PORT', 3000) }", env: 'development'
template 'lib/tasks/auto_annotate_models.rake'
# TODO break out ENV vars into their relevant generators with append_to_file?
template '.env'
template '.env', '.env.example'
template 'Procfile'
append_to_file '.gitignore', '.env'
commit "performs some additional configuration"

# copy default application interaction
template 'app/interactions/application_interaction.rb'
commit "adds a default application interaction"


after_bundle do
  commit "bundles and prepares application"

  generate 'greenhill:webpack:typescript'
  generate 'greenhill:webpack:react'
  generate 'greenhill:webpack:jest'
  generate 'greenhill:webpack:eslint'
  generate 'greenhill:webpack:storybook'
  generate 'greenhill:webpack:styled'
  generate 'greenhill:webpack:boilerplate'
  # TODO any additional loaders: icons, css, url, etc.
  # TODO axios, react-router, (react-query / apollo)
  # TODO finish cleaning up and standardize generator templates (.tt vs not)
  # TODO reorganize and clean up theme primitives in a way that's more customizable

  generate 'rspec:install'
  prepend_to_file 'spec/spec_helper.rb', <<-COVERAGE
  # Load and launch SimpleCov at the very top of your spec_helper.rb
  # SimpleCov.start must be issued before any of your application code is required
  # See https://github.com/simplecov-ruby/simplecov#getting-started
  require 'simplecov'
  SimpleCov.start\n
COVERAGE
  commit "runs rspec install generator and configures with simplecov"

  generate 'greenhill:sidekiq:install'
  generate 'greenhill:devise:install'
  generate 'greenhill:pundit:install'
  generate 'greenhill:graphql:install'
  generate "greenhill:admin:install"

  generate "zuul:install"
  commit "runs zuul:install generator"

  # TODO specs / factories
  generate 'greenhill:user User'

  # initialize the application database, dumps graphql schema and generates graphql types
  rails_command "db:create db:migrate db:seed graphql:types", abort_on_failure: true
  commit "initializes database and generates graphql types"

  run "yarn test"
  commit "runs frontend tests and generates initial snapshots"

  # TODO TEMPORARY run linter while developing to keep on top of it
  run "yarn lint"
end