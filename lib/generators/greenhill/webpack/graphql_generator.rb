# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Webpack
    module Generators
      class GraphqlGenerator < Rails::Generators::Base
        include Greenhill::Generators::CommitHelper

        desc "Install and configure GraphQL client and codegen via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

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
      end
    end
  end
end