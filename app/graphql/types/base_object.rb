# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    # Explicit :: — a bare reference here hits Zeitwerk's nested-lookup
    # autoloading (tries Types::BaseObject::Punditable) before falling back
    # to the real top-level constant, which only works by load-order luck.
    include ::Punditable

    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField
  end
end
