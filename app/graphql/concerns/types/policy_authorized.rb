# frozen_string_literal: true

module Types
  # Opt-in, per-object authorization for object types backed by a model:
  # GraphQL-Ruby calls `authorized?` for every object it resolves to this
  # type, whichever field or `node` lookup it came through, and the object
  # resolves to null when the record's policy denies `show?`.
  module PolicyAuthorized
    extend ActiveSupport::Concern

    class_methods do
      def authorized?(object, context)
        super && Pundit.policy!(context[:current_user], object).show?
      end
    end
  end
end
