require "flipper/adapters/redis"

Flipper.configure do |config|
  config.adapter do
    if Rails.env.test?
      Flipper::Adapters::Memory.new
    else
      # Defaults to the same instance as Sidekiq (see
      # config/initializers/sidekiq.rb) — both need noeviction, so flag
      # state never silently disappears under memory pressure. Kept as
      # its own env var so it can move to a dedicated instance later
      # without a code change.
      Flipper::Adapters::Redis.new(Redis.new(url: ENV.fetch("FLIPPER_REDIS_URL", "redis://localhost:6379/0")))
    end
  end
end
