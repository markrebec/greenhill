# frozen_string_literal: true

module Mutations
  # A base class for mutations whose work is offloaded to an interaction —
  # `resolve` just returns the interaction's outcome directly, and this
  # translates it into a GraphQL response based on the mutation's declared
  # fields, including the `errors` field (added automatically).
  class InteractionMutation < Mutations::BaseMutation
    description 'A mutation whose work is offloaded to an interaction.'

    field :errors, [Types::ClientError], null: false, description: 'Validation or authorization errors, if any.'

    # Set after declaring :errors above, so resolve_with_support can tell
    # mutation-declared fields apart from this class' own built-in ones.
    field_class Types::InteractionMutationField

    def resolve_with_support(**inputs)
      result = super
      return result unless result.is_a?(Graphqlable)

      interaction_result_fields(result).merge(errors: result.errors.to_graphql(field.path.split('.')),
                                              client_mutation_id: inputs[:input][:client_mutation_id])
    rescue Pundit::NotAuthorizedError
      { errors: [not_authorized_error], client_mutation_id: inputs[:input][:client_mutation_id] }
    end

    private

    def interaction_result_fields(result)
      field.type.fields
           .select { |_name, mutation_field| mutation_field.is_a?(self.class.field_class) }
           .to_h do |name, mutation_field|
             [name.underscore.to_sym, result.to_graphql(mutation_field.interaction_result_from,
                                                        partial: mutation_field.interaction_partial_result)]
           end
    end

    def not_authorized_error
      { message: 'You are not authorized to perform this action.', code: 'notAuthorized', path: field.path.split('.') }
    end
  end
end
