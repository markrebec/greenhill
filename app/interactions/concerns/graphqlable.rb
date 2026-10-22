# frozen_string_literal: true

module Graphqlable
  extend ActiveSupport::Concern

  # Returns the interaction's result in a form usable in a GraphQL response.
  #
  # @param from [Symbol, Proc, nil] An optional method or proc to call and return as the result.
  # @param partial [Boolean] Whether a result is returned alongside failures (i.e. for partial successes).
  def to_graphql(from = nil, partial: true)
    return nil unless valid? || partial

    from.is_a?(Proc) ? instance_exec(&from) : send(from || :result)
  end

  class_methods do
    # Tap into interaction initialization to inject GraphQL helper methods onto the errors object.
    def new(*)
      super.tap { |instance| instance.errors.class_eval { include Errors } }
    end
  end

  module Errors
    # Translates all interaction errors into GraphQL mutation-compatible error hashes.
    #
    # @param path [Array<String>] An optional array of path parts for errors.
    # @return [Array<Hash>] Errors translated into { message:, code:, path: } hashes.
    def to_graphql_errors(path = [])
      @errors.map do |error|
        {
          message: error.full_message,
          code: error.type.to_s.parameterize.underscore.camelize(:lower),
          path: path + [error.attribute&.to_s&.camelize(:lower)].compact
        }
      end
    end
    alias to_graphql to_graphql_errors

    # Wraps all errors in a GraphQL::ExecutionError, for raising manually.
    #
    # @param message [String, nil] An optional message for the error.
    # @param path [Array<String>] An optional array of path parts for errors.
    # @return [GraphQL::ExecutionError]
    def to_graphql_execution_error(message = nil, path = [])
      GraphQL::ExecutionError.new(
        message || "#{count} error(s) occurred",
        extensions: {
          errors: to_graphql_errors(path),
          messages: @errors.map(&:full_message),
          path: path
        }
      )
    end
  end
end
