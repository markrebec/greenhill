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
          run "yarn add typescript"
          template "tsconfig.json"
          commit "installs and configures typescript"
        end

        def install_and_configure_preset
          run "yarn add @babel/core @babel/preset-typescript"
          inject_into_file 'babel.config.js',
            "        ['@babel/preset-typescript', { 'allExtensions': true, 'isTSX': true }],",
            after: "presets: [\n"
          commit "installs and configures babel typescript preset"
        end

        def install_and_configure_plugin
          run "yarn add fork-ts-checker-webpack-plugin"
          inject_into_file 'config/webpack/development.js', after: "const environment = require('./environment')\n" do <<-REQUIRE
const path = require("path")
const ForkTsCheckerWebpackPlugin = require("fork-ts-checker-webpack-plugin")
REQUIRE
          end
          inject_into_file 'config/webpack/development.js', before: "\nmodule.exports = environment.toWebpackConfig()" do <<-PLUGIN
environment.plugins.append(
  "ForkTsCheckerWebpackPlugin",
  new ForkTsCheckerWebpackPlugin({
    typescript: {
      configFile: path.resolve(__dirname, "../../tsconfig.json"),
      // non-async so type checking will block compilation
      async: false,
    }
  })
)
PLUGIN
          end
          commit "installs and configures blocking type checking for webpack"
        end

        def enable_extensions
          inject_into_file 'config/webpacker.yml', after: "  extensions:\n" do <<-EXTENSIONS
    - .ts
    - .tsx
EXTENSIONS
          end
          commit "enables typescript extensions in webpacker"
        end

        def install_types
          run "yarn add @types/rails__activestorage @types/rails__ujs @types/webpack-env"
          commit "installs relevant type libraries for rails/webpack"
        end

        def install_core_dependencies
          run "yarn add lodash @types/lodash"
          commit "installs additional core dependencies"
        end
      end
    end
  end
end
