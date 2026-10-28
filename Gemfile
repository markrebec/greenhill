# frozen_string_literal: true

source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.3", ">= 8.1.3.1"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Use the database-backed adapter for Action Cable
gem "solid_cable"

# Redis client — backs the Rails cache store, Sidekiq, and Flipper (see each
# gem's own section below)
gem "redis"

# Background job processing, backed by Redis (see config/initializers/sidekiq.rb).
# sidekiq-scheduler adds cron-like recurring jobs, sidekiq-unique-jobs dedupes/
# prevents concurrent-duplicate jobs, sidekiq-throttled adds per-job rate/
# concurrency limiting — open-source equivalents of Sidekiq Pro/Enterprise
# features we don't want to pay for.
gem "sidekiq"
gem "sidekiq-scheduler"
gem "sidekiq-throttled"
gem "sidekiq-unique-jobs"

# Feature flagging, backed by the same Redis instance as Sidekiq (see
# config/initializers/flipper.rb) — flag state needs noeviction too.
gem "flipper"
gem "flipper-redis"
gem "flipper-ui"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 2.2"

# Vite integration — single dev URL (Rails renders the view; the vite_*_tag
# helpers point at the Vite dev server for the actual JS/HMR), same view
# code resolves to the built manifest in production. Direct successor to
# webpacker/shakapacker for Vite instead of webpack.
gem "vite_rails"

# Authentication
gem "devise"

# Authorization
gem "pundit"

# Admin dashboard. Needs Sprockets for its own assets (Rails 8 defaults to
# Propshaft; ActiveAdmin 3.x doesn't support it yet, 4.0's support is still
# beta) — scoped to ActiveAdmin's own assets only, doesn't touch the separate
# bun+Vite pipeline for the main app.
gem "activeadmin"
gem "sassc"
gem "sprockets-rails"

# GraphQL API
gem "graphql"

# In-browser GraphQL IDE, mounted at /admin/graphiql (see config/routes.rb)
# gated behind an AdminUser session — not development-only, since the gate
# is auth, not environment.
gem "graphiql-rails"

# Service object layer — business logic lives in ActiveInteraction classes
# (app/interactions/), not controllers/models. See ApplicationInteraction.
gem "active_interaction"

# Tracks one-off data migrations (db/data_schema.rb) separately from schema
# migrations (db/schema.rb) — `bin/rails g data_migration <name>`.
gem "data_migrate"

# Turns blank string attributes into nil before validation/save. Not wired
# into any model yet (`nilify_blanks` is opt-in per-model) — greenhill's only
# models so far are Devise-managed (User/AdminUser) with NOT NULL
# default("") string columns that this would break if applied globally.
gem "nilify_blanks"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Static code analysis
  gem "rubocop", require: false
  gem "rubocop-graphql", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false

  # RSpec test framework
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"

  # Test coverage reporting
  gem "simplecov", require: false

  # Matchers for testing Pundit policies (permit/forbid). require: false
  # because the gem's actual require path is 'pundit/matchers', not
  # 'pundit-matchers' (no top-level entry file matching the gem name).
  gem "pundit-matchers", require: false

  # Loads env vars from .env
  gem "dotenv-rails"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Annotates models, factories, fixtures, etc. with schema info. Successor to
  # the unmaintained `annotate` gem.
  gem "annotaterb"

  # Pretty-prints objects in bin/rails console and other dev-only output.
  gem "amazing_print"
end
