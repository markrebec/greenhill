# frozen_string_literal: true

module Mutations
  class UpdatePassword < Mutations::BaseMutation
    description 'Updates the signed-in user\'s password.'

    argument :current_password, String, required: true, description: "The user's current password."
    argument :password, String, required: true, description: 'The new password.'
    argument :password_confirmation, String, required: true, description: 'Confirmation of the new password.'

    field :errors, [String], null: false, description: 'Validation or authorization errors, if any.'
    field :user, Types::UserType, null: true, description: 'The updated user, if successful.'

    # Explicit :: to reach the top-level interaction, not this mutation class
    # itself (both are named UpdatePassword, in different namespaces).
    def resolve(current_password:, password:, password_confirmation:)
      current_user = context[:current_user]
      authorize(current_user, :update?) if current_user

      outcome = ::UpdatePassword.run(user: current_user, current_password: current_password,
                                     password: password, password_confirmation: password_confirmation)

      return { user: nil, errors: outcome.errors.full_messages } unless outcome.valid?

      { user: outcome.result, errors: [] }
    end
  end
end
