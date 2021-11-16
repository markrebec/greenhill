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

          commit "enables current_user context in graphql controller"
        end

        def mount_graphiql
          route <<-ROUTE

  authenticate :user, ->(user) { user.admin? } do
    mount GraphiQL::Rails::Engine, at: '/admin/graphiql', graphql_path: '/graphql'
  end

ROUTE

          commit "mounts graphiql within admin namespace and wrapped in admin user auth"
        end

        def schema_dump_task
          template 'lib/tasks/graphql.rake'
          commit "adds a rake task to dump the GraphQL schema"
        end

        def install_client
          run "yarn add graphql graphql-request"
          commit "installs graphql and graphql-request client packages"
        end

        def install_codegen
          run "yarn add @graphql-codegen/cli @graphql-codegen/typescript @graphql-codegen/typescript-graphql-request"
          template 'codegen.yml'
          run "npx --yes npm-add-script -k \"graphql:types\" -v \"bin/rails graphql:schema:dump && graphql-codegen\" --force"
          commit "installs graphql-codegen to generate types from the schema"
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