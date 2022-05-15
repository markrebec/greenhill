# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Graphql
    module Generators
      class InstallGenerator < Rails::Generators::Base
        include Greenhill::Generators::CommitHelper

        desc "Install and configure GraphQL with GraphQL Batch and GraphiQL via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        # TODO add an option for schema filename(s)?

        def install_graphql
          generate 'graphql:install'
          commit "runs graphql:install generator"
        end

        def configure_batch_loaders
          template 'app/graphql/record_loader.rb'
          template 'app/graphql/association_loader.rb'

          prepend_to_file schema_file_path, "require 'graphql/batch'\n\n"
          inject_into_file schema_file_path, "\n  use(GraphQL::Batch)",
            after: "query(Types::QueryType)"

          commit "configures graphql to use graphql-batch with default loaders"
        end

        def enable_user_context
          gsub_file 'app/controllers/graphql_controller.rb',
            /# current_user: current_user/,
            'current_user: current_user'

          gsub_file 'app/controllers/graphql_controller.rb',
            /# protect_from_forgery with: :null_session/,
            'protect_from_forgery with: :null_session'

          commit "enables current_user context and api-style forgery protection in graphql controller"
        end

        def mount_graphiql
          template 'config/initializers/graphql.rb'
          graphiql_route = <<-ROUTE

  authenticate :admin, ->(user) { user.admin? } do
    mount GraphiQL::Rails::Engine, at: '/admin/graphiql', graphql_path: '/graphql'
  end

ROUTE

          gsub_file 'config/routes.rb',
          /if Rails\.env\.development\?\n    mount GraphiQL::Rails::Engine, at: "\/graphiql", graphql_path: "\/graphql"\n  end/,
          graphiql_route

          commit "mounts graphiql within admin namespace and wrapped in admin user auth"
        end

        def schema_dump_task
          template 'lib/tasks/graphql.rake'
          commit "adds a rake task to dump the GraphQL schema"
        end

        private

        def schema_file_path
          @schema_file_path ||= begin
            path = File.join('app', 'graphql')
            file = Dir.children(path).select { |f| f.match?(/[a-z0-9_]+_schema\.rb$/) }.first
            File.join(path, file)
          end
        end

        def schema_class_name
          @schema_class_name ||= File.basename(schema_file_path, '.rb').classify
        end
      end
    end
  end
end