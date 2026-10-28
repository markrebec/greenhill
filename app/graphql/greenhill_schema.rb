# frozen_string_literal: true

class GreenhillSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # For batch-loading (see https://graphql-ruby.org/dataloader/overview.html)
  use GraphQL::Dataloader

  # GraphQL-Ruby calls this when something goes wrong while running a query:
  # a fallback for plain queries (no `errors` field to fold into) and any
  # mutation that doesn't inherit from Mutations::InteractionMutation, which
  # catches this same error itself and folds it into its own `errors` field.
  rescue_from(Pundit::NotAuthorizedError) do |_err, _obj, _args, _ctx, _field|
    raise GraphQL::ExecutionError, "You are not authorized to perform this action."
  end

  # Union and Interface Resolution
  def self.resolve_type(_abstract_type, _obj, _ctx)
    # TODO: Implement this method
    # to return the correct GraphQL object type for `obj`
    raise(GraphQL::RequiredImplementationMissingError)
  end

  # Limit the depth and size of incoming queries:
  max_depth(15)
  max_query_string_tokens(5000)
  max_complexity(300)

  # Stop validating when it encounters this many errors:
  validate_max_errors(100)

  # Relay-style Object Identification:

  # Return a string UUID for `object`
  def self.id_from_object(object, _type_definition, _query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    object.to_gid_param
  end

  # Given a string UUID, find the object
  def self.object_from_id(global_id, _query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    GlobalID.find(global_id)
  end
end
