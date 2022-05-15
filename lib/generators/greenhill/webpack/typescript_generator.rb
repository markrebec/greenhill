# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Webpack
    module Generators
      class TypescriptGenerator < Rails::Generators::Base
        include Greenhill::Generators::CommitHelper

        desc "Install and configure typescript via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        def install_and_configure_typescript
          run "yarn add typescript @babel/preset-typescript"
          template "tsconfig.json"
          # inject_into_file 'babel.config.js',
          #   "      ['@babel/preset-typescript', { 'allExtensions': true, 'isTSX': true }],\n",
          #   after: "presets: [\n"
          commit "installs and configures typescript and babel preset"
        end

        def install_and_configure_plugin
          run 'yarn add fork-ts-checker-webpack-plugin'
          inject_into_file 'config/webpack/webpack.config.js',
            "const ForkTSCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin');\n",
            after: "const { webpackConfig, merge } = require('shakapacker');\n"
          inject_into_file 'config/webpack/webpack.config.js',
            "    new ForkTSCheckerWebpackPlugin()\n",
            after: "plugins: [\n"
          commit "installs and configures type checking for webpack"
        end

        def enable_extensions
          # TODO not needed with shakapacker / webpack 5 ?
#           inject_into_file 'config/webpacker.yml', after: "  extensions:\n" do <<-EXTENSIONS
#     - .ts
#     - .tsx
# EXTENSIONS
#           end
          commit "enables typescript extensions in webpacker"
        end

        def install_types
          run "yarn add @types/rails__activestorage @types/rails__ujs @types/webpack-env"
          commit "installs relevant type libraries for rails/webpack"
        end

        def install_core_dependencies
          run "yarn add lodash @types/lodash axios"
          commit "installs additional core dependencies"
        end
      end
    end
  end
end
