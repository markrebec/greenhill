# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    admin? || own_record?
  end

  def update?
    admin? || own_record?
  end

  private

  def own_record?
    pundit_user.present? && record == pundit_user
  end
end
