# frozen_string_literal: true

require "webmock/rspec"

# Specs must never reach the real network — stub every outbound request.
# Localhost stays reachable for anything that talks to local services.
WebMock.disable_net_connect!(allow_localhost: true)
