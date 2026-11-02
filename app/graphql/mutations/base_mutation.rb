# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    # Explicit :: — see the same note in Types::BaseObject.
    include ::Punditable

    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    private

    # The signed-in application user; refuses admins and anonymous callers.
    # InteractionMutation turns the refusal into a notAuthorized error.
    def signed_in_user!
      user = context[:current_user]
      raise Pundit::NotAuthorizedError, "must be signed in" unless user.is_a?(User)

      user
    end
  end
end
