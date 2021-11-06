# frozen_string_literal: true
require 'rails/generators'
require 'generators/graphql/object_generator'

module Rails
  module Generators
    class TypeGenerator < ::Graphql::Generators::ObjectGenerator
      source_root ::Graphql::Generators::ObjectGenerator.source_root

      # normally this would be read from the schema, but we can do a pretty good job
      # by basing it on the provided field arguments and piggybacking on that
      # feature from the graphql:object generator in the meantime.
      def fields
        columns = []
        columns += [
          'id:uuid',
          custom_fields,
          'created_at:datetime',
          'updated_at:datetime',
        ].flatten.map do |col|
          name, type = col.split(':')
          null = !(name.in?(['id', 'created_at', 'updated_at']) || type == 'references')
          type = name if type == 'references'
          col = Struct.new(:name, :type, :null).new(name, type, null)
          generate_column_string(col)
        end
        columns
      end

      private

      def column_type_string(column)
        id_column?(column) ? "ID" : column.type.to_s.camelize
      end

      def id_column?(column)
        column.type.in?(['references', 'uuid']) ||
          column.name.match(/^([a-z0-9_]*_)?id$/)
      end
    end
  end
end
