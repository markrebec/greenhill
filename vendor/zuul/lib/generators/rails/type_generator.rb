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
        ].flatten.map do |c|
          name, type = c.split(':')
          null = !name.in?(['id', 'created_at', 'updated_at'])
          col = Struct.new(:name, :type, :null).new(name, type, null)
          generate_column_string(col)
        end
        columns
      end
    end
  end
end
