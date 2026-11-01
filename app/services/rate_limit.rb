# frozen_string_literal: true

# Fixed-window rate limiting on Rails.cache (Redis in production): at most
# `limit` hits per `period` for a key. When the cache can't count (the null
# store in tests), everything is allowed.
#
#   RateLimit.new("add_podcast:#{user.id}", limit: 20, period: 1.hour).allow?
class RateLimit
  def initialize(key, limit:, period:, store: Rails.cache, clock: -> { Time.current })
    @key = key
    @limit = limit
    @period = period.to_i
    @store = store
    @clock = clock
  end

  # Records a hit and returns whether it's within the limit.
  def allow?
    count = @store.increment(window_key, 1, expires_in: @period)
    count.nil? || count <= @limit
  end

  private

  def window_key
    "rate_limit:#{@key}:#{@clock.call.to_i / @period}"
  end
end
