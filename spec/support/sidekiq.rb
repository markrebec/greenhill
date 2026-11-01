# frozen_string_literal: true

require "sidekiq/testing"
require "sidekiq_unique_jobs/testing"

# Native Sidekiq::Job pushes land in in-memory queues (inspect with
# `MyJob.jobs`, run with `MyJob.drain`). sidekiq-unique-jobs is disabled so
# its client middleware never takes real Redis locks from specs — leave
# testing uniqueness itself to the gem.
Sidekiq::Testing.fake!
SidekiqUniqueJobs.config.enabled = false

RSpec.configure do |config|
  config.before { Sidekiq::Job.clear_all }
end
