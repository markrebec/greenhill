# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
    respond_to :json
  end
end
