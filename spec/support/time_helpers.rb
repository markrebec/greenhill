# frozen_string_literal: true

# travel_to / travel / freeze_time in any spec type. The explicit travel_back
# covers example groups that don't get Rails' minitest lifecycle hooks.
RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.after { travel_back }
end
