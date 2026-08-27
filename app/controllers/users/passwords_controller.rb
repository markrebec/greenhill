# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    respond_to :json
  end
end
