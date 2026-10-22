# frozen_string_literal: true

# graphql-ruby's generator never sets up a non-namespacing `concerns`
# directory the way Rails does for app/models/concerns and
# app/controllers/concerns (both are registered as their own root, not
# just collapsed, per Rails' own autoloading guide). Without this,
# app/graphql/concerns/foo.rb would need to define Concerns::Foo, since
# app/graphql itself is already a root (every direct child of app/ is) and
# a concerns/ subdirectory under it gets no special treatment by default.
Rails.application.config.eager_load_paths << Rails.root.join("app/graphql/concerns")
