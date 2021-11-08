# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'

module Zuul
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Install Zuul boilerplate for GraphQL + Pundit"
      # source_root File.expand_path('../templates', __FILE__)

      def inject_zuul_into_schema
        inject_into_file schema_file_path,
          "\n  context_class(Zuul::Pundit::Context)",
          after: "query(Types::QueryType)"
      end

      def inject_zuul_into_types
        inject_into_file "app/graphql/types/base_object.rb",
          "\n    extend Zuul::Pundit::Object",
          after: "class BaseObject < GraphQL::Schema::Object"
    
        inject_into_file "app/graphql/types/base_field.rb",
          "\n    include Zuul::Pundit::Field",
          after: "class BaseField < GraphQL::Schema::Field"
    
        inject_into_file "app/graphql/types/base_argument.rb",
          "\n    include Zuul::Pundit::Argument",
          after: "class BaseArgument < GraphQL::Schema::Argument"
    
        inject_into_file "app/graphql/types/query_type.rb",
          "\n    pundit_role nil",
          after: "class QueryType < Types::BaseObject"
    
        inject_into_file "app/graphql/types/mutation_type.rb",
          "\n    pundit_role nil",
          after: "class MutationType < Types::BaseObject"
      end

      private

      def schema_file_path
        @schema_file_path ||= begin
          path = File.join('app', 'graphql')
          file = Dir.children(path).select { |f| f.match?(/[a-z0-9_]+_schema\.rb$/) }.first
          File.join(path, file)
        end
      end
    end
  end
end