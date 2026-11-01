# frozen_string_literal: true

require "rails_helper"

RSpec.describe RateLimit do
  let(:store) { ActiveSupport::Cache::MemoryStore.new }
  let(:now) { Time.utc(2026, 11, 1, 12, 0, 0) }

  def limiter(key = "spec", at: now)
    described_class.new(key, limit: 2, period: 1.hour, store: store, clock: -> { at })
  end

  it "allows hits up to the limit, then refuses", :aggregate_failures do
    expect(limiter.allow?).to be true
    expect(limiter.allow?).to be true
    expect(limiter.allow?).to be false
  end

  it "counts keys separately" do
    2.times { limiter("one").allow? }
    expect(limiter("two").allow?).to be true
  end

  it "starts a fresh window after the period" do
    3.times { limiter.allow? }
    expect(limiter(at: now + 1.hour).allow?).to be true
  end

  it "allows everything when the cache can't count" do
    null = described_class.new("spec", limit: 0, period: 1.hour, store: ActiveSupport::Cache::NullStore.new)
    expect(null.allow?).to be true
  end
end
