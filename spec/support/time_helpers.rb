# frozen_string_literal: true

# travel_to / travel / freeze_time in every spec type. Rails resets time
# after each example on its own, so no explicit travel_back is needed.
RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
end
