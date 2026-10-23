require "sidekiq-unique-jobs"
require "sidekiq/throttled"

# Shared with Flipper (see config/initializers/flipper.rb) — both need
# noeviction, so they live on the same Redis instance.
redis_config = { url: ENV.fetch("SIDEKIQ_REDIS_URL", "redis://localhost:6379/0") }

Sidekiq.configure_server do |config|
  config.redis = redis_config

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  SidekiqUniqueJobs::Server.configure(config)
end

Sidekiq.configure_client do |config|
  config.redis = redis_config

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end
