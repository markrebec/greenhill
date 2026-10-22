# frozen_string_literal: true

# Several gems' own Rails generators (graphql-ruby, ActiveInteraction) never
# set up a non-namespacing `concerns` directory the way Rails does for
# app/models/concerns and app/controllers/concerns (both are registered as
# their own root, not just collapsed, per Rails' own autoloading guide).
# Without this, app/graphql/concerns/foo.rb would need to define
# Concerns::Foo, since app/graphql itself is already a root (every direct
# child of app/ is) and a concerns/ subdirectory under it gets no special
# treatment by default. Same reasoning applies to app/interactions/concerns.
Rails.application.config.eager_load_paths << Rails.root.join("app/graphql/concerns")
Rails.application.config.eager_load_paths << Rails.root.join("app/interactions/concerns")
