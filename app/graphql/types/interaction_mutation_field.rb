# frozen_string_literal: true

module Types
  class InteractionMutationField < Types::BaseField
    attr_reader :interaction_result_from, :interaction_partial_result

    def initialize(*, from: :result, partial: true, **kwargs, &)
      # Always default to null: true, to stay compatible with partial results.
      kwargs[:null] = true unless kwargs.key?(:null)
      @interaction_result_from = from
      @interaction_partial_result = partial

      super(*, **kwargs, &)
    end
  end
end
