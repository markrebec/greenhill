# frozen_string_literal: true

class UpdatePassword < ApplicationInteraction
  object :user, class: 'User'
  string :current_password
  string :password
  string :password_confirmation

  validate :current_password_must_be_valid

  def execute
    user.update(password: password, password_confirmation: password_confirmation)
    errors.merge!(user.errors) if user.errors.any?
    user
  end

  private

  def current_password_must_be_valid
    errors.add(:current_password, :invalid) unless user.valid_password?(current_password)
  end
end
