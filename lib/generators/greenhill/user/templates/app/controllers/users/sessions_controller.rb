# frozen_string_literal: true
require 'responders/auth_json_responder'

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]


  responders :auth_json
  respond_to :json
  protect_from_forgery with: :null_session

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
