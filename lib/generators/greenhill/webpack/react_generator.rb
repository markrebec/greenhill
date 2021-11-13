# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Webpack
    module Generators
      class ReactGenerator < Rails::Generators::Base
        include Greenhill::Generators::CommitHelper

        desc "Configure React for Typescript and HMR via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        def add_types
          run "yarn add -D @types/react @types/react-dom"
          commit "adds react typescript types"
        end

        def install_and_configure_plugin
          run "yarn add -D react-refresh @pmmmwh/react-refresh-webpack-plugin"

          inject_into_file 'config/webpack/development.js', after: "const environment = require('./environment')\n" do <<-REQUIRE
const ReactRefreshWebpackPlugin = require('@pmmmwh/react-refresh-webpack-plugin')
REQUIRE
          end            
          inject_into_file 'config/webpack/development.js', before: "\nmodule.exports = environment.toWebpackConfig()" do <<-PLUGIN
if (environment.config.devServer) {
  environment.plugins.append("ReactRefreshWebpackPlugin", new ReactRefreshWebpackPlugin())
}
PLUGIN
          end

          commit "installs and configures react-refresh + webpack plugin"
        end

        def enable_hmr
          gsub_file 'config/webpacker.yml', /    hmr: false/, '    hmr: true'
          commit "enables HMR in webpacker config"
        end

        def move_dev_dependencies
          run "yarn remove @babel/preset-react babel-plugin-transform-react-remove-prop-types prop-types"
          run "yarn add -D @babel/preset-react"
          gsub_file 'babel.config.js', /      isProductionEnv && \[\n        'babel-plugin-transform-react-remove-prop-types',\n        {\n          removeImport: true\n        }\n      \]\n/, ''
          commit "removes prop-types and moves babel react preset to dev dependencies"
        end
      end
    end
  end
end
