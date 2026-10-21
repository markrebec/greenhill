# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :update_password, mutation: Mutations::UpdatePassword
  end
end
