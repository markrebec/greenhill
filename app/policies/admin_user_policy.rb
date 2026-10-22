# frozen_string_literal: true

class AdminUserPolicy < ApplicationPolicy
  # Inherits ApplicationPolicy's admin?-gated defaults as-is — any signed-in
  # AdminUser can manage AdminUser records, matching today's trust model
  # (flat, no role hierarchy). Add overrides here if that ever needs to
  # change (e.g. an admin can't delete themselves).
end
