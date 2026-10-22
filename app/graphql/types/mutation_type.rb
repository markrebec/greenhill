# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description "The entry point for all GraphQL mutations."

    field :update_password, mutation: Mutations::UpdatePassword
  end
end
