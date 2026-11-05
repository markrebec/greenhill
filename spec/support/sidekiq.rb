# frozen_string_literal: true

require "sidekiq/testing"
require "sidekiq_unique_jobs/testing"

# Native Sidekiq::Job pushes land in in-memory queues (inspect with
# `MyJob.jobs`, run with `MyJob.drain`). sidekiq-unique-jobs is disabled so
# its client middleware never takes real Redis locks from specs — leave
# testing uniqueness itself to the gem.
Sidekiq::Testing.fake!
SidekiqUniqueJobs.config.enabled = false

# Sidekiq::Queues, not Sidekiq::Job: sidekiq-unique-jobs patches
# Sidekiq::Job.clear_all to also delete lock digests from Redis, which would
# make every spec need a live Redis. With uniqueness disabled there are no
# digests to delete.
RSpec.configure do |config|
  config.before { Sidekiq::Queues.clear_all }
end
