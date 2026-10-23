# frozen_string_literal: true

module Types
  module Associations
    extend ActiveSupport::Concern

    class_methods do
      # Declares a field backed by an ActiveRecord association, batch-loaded
      # via dataload_association (see GraphQL::Schema::Member::HasDataloader)
      # instead of resolving it directly -- interchangeable with `field`
      # regardless of whether the association is a belongs_to/has_one/has_many,
      # since dataload_association delegates to Rails' own Preloader either way.
      #
      # rubocop:disable Style/ArgumentsForwarding -- kwargs/block are forwarded
      # alongside named args (to:, scope:) that are consumed, not forwarded;
      # rubocop's anonymous-forwarding autocorrect for this mix produces
      # invalid syntax.
      def association(field_name, type, to: field_name, scope: nil, **kwargs, &block)
        field field_name, type, **kwargs, &block

        define_method(field_name) do
          resolved_scope = scope.respond_to?(:call) ? instance_exec(&scope) : scope
          dataload_association(to, scope: resolved_scope)
        end
      end
      # rubocop:enable Style/ArgumentsForwarding
    end
  end
end
