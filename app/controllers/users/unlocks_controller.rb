# frozen_string_literal: true

module Users
  class UnlocksController < Devise::UnlocksController
    respond_to :json
  end
end
