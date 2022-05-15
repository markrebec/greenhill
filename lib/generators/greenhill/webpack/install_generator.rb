# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Webpack
    module Generators
      class InstallGenerator < Rails::Generators::Base
        include Greenhill::Generators::CommitHelper

        desc "Install and configure webpack via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        def install_and_configure_yarn
          run "yarn set version berry"
          append_to_file '.yarnrc.yml', 'nodeLinker: node-modules'
          append_to_file '.gitignore', <<-IGNORE

# Ignore rules for yarn 2.0
node_modules
.pnp.*
.yarn/*
!.yarn/patches
!.yarn/plugins
!.yarn/releases
!.yarn/sdks
!.yarn/versions
IGNORE
          run "rm -f package.json"
          commit "installs and configures yarn 2.0"
        end

        def install_and_configure_webpack
          rails_command "webpacker:install"
          template 'babel.config.js'
          gsub_file 'package.json',
            "  \"babel\": {\n    \"presets\": [\n      \"./node_modules/shakapacker/package/babel/preset.js\"\n    ]\n  },\n",
            ''
          run 'rm -f config/webpack/webpack.config.js'
          template 'config/webpack/webpack.config.js'
          commit "installs and configures webpack via shakapacker"
        end

        def install_and_configure_dependencies
          generate 'greenhill:webpack:typescript'
          generate 'greenhill:webpack:react'
          generate 'greenhill:webpack:graphql'
          generate 'greenhill:webpack:jest'
          generate 'greenhill:webpack:eslint'
          generate 'greenhill:webpack:styled'
          generate 'greenhill:webpack:storybook'
          generate 'greenhill:webpack:boilerplate'
          # TODO any additional loaders: icons, css, url, etc.
          # TODO axios, react-router, (react-query / apollo)
          # TODO finish cleaning up and standardize generator templates (.tt vs not)
          # TODO reorganize and clean up theme primitives in a way that's more customizable
        end
      end
    end
  end
end
