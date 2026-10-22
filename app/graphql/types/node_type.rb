# frozen_string_literal: true

module Types
  module NodeType
    include Types::BaseInterface
    # Add the `id` field
    include GraphQL::Types::Relay::NodeBehaviors

    description 'An object with a globally unique ID.'
  end
end
