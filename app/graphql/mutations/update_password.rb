# frozen_string_literal: true

module Mutations
  class UpdatePassword < Mutations::BaseMutation
    argument :current_password, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    # Explicit :: to reach the top-level interaction, not this mutation class
    # itself (both are named UpdatePassword, in different namespaces).
    def resolve(current_password:, password:, password_confirmation:)
      outcome = ::UpdatePassword.run(user: context[:current_user], current_password: current_password,
                                     password: password, password_confirmation: password_confirmation)

      return { user: nil, errors: outcome.errors.full_messages } unless outcome.valid?

      { user: outcome.result, errors: [] }
    end
  end
end
