# frozen_string_literal: true

class ApplicationPolicy
  # Renamed from the generator's `user` — the actor here can be a `User` or
  # an `AdminUser` (see `admin?` below), so `pundit_user` avoids confusion
  # with the `User` AR model specifically.
  attr_reader :pundit_user, :record

  def initialize(pundit_user, record)
    @pundit_user = pundit_user
    @record = record
  end

  # Admins get free reign by default; everything else is default-deny
  # unless a subclass ORs in its own rule (see UserPolicy).
  def index?
    admin?
  end

  def show?
    admin?
  end

  def create?
    admin?
  end

  def new?
    create?
  end

  def update?
    admin?
  end

  def edit?
    update?
  end

  def destroy?
    admin?
  end

  class Scope
    def initialize(pundit_user, scope)
      @pundit_user = pundit_user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :pundit_user, :scope
  end

  private

  def admin?
    pundit_user.is_a?(AdminUser)
  end
end
