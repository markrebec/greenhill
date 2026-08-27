# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    # JSON-only controllers aren't carrying a Rails CSRF token from the SPA.
    skip_before_action :verify_authenticity_token
  end
end
