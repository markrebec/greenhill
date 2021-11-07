# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'

module Greenhill
  module Graphql
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc "Install and configure GraphQL with GraphQL Batch and GraphiQL via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        # TODO add an option for schema filename(s)?

        def install_graphql
          generate 'graphql:install'
        end

        def configure_batch_loaders
          template 'record_loader.rb', 'app/graphql/record_loader.rb'
          template 'association_loader.rb', 'app/graphql/association_loader.rb'

          prepend_to_file schema_file_path, "require 'graphql/batch'\n\n"
          inject_into_file schema_file_path, "\n  use(GraphQL::Batch)",
            after: "query(Types::QueryType)"
        end

        def enable_user_context
          gsub_file 'app/controllers/graphql_controller.rb',
            /# current_user: current_user/,
            'current_user: current_user'
        end

        def mount_graphiql
          route <<-ROUTE
  authenticate :user, ->(user) { user.admin? } do
    mount GraphiQL::Rails::Engine, at: '/admin/graphiql', graphql_path: '/graphql'
  end
ROUTE
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
end