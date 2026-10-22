# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description "The entry point for all GraphQL queries."

    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, { null: true }], null: true,
                                                     description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :me, Types::UserType, null: true, description: "The currently signed-in user."
    def me
      current_user = context[:current_user]
      return nil unless current_user

      authorize(current_user, :show?)
    end
  end
end
