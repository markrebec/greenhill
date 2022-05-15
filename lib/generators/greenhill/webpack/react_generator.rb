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

        def add_react
          run "yarn add react@^17.0.1 react-dom@^17.0.1 @types/react@^17.0.1 @types/react-dom@^17.0.1 @babel/preset-react"
          inject_into_file 'package.json', before: "  }\n}" do <<-RESOLUTIONS
  },
  "resolutions": {
    "@types/react": "^17.0.1"
RESOLUTIONS
          end
          inject_into_file 'babel.config.js', after: "presets: [\n" do <<-BABEL
      [
        '@babel/preset-react',
        {
          development: isDevelopmentEnv || isTestEnv,
          useBuiltIns: true
        }
      ],
BABEL
          end
          commit "adds react with types and babel preset"
        end

        def install_and_configure_plugin
          run "yarn add react-refresh @pmmmwh/react-refresh-webpack-plugin"

          inject_into_file 'config/webpack/webpack.config.js', after: "const { webpackConfig, merge } = require('shakapacker');\n" do <<-REQUIRE
const ReactRefreshWebpackPlugin = require('@pmmmwh/react-refresh-webpack-plugin');
REQUIRE
          end

          inject_into_file 'config/webpack/webpack.config.js',
            "    new ReactRefreshWebpackPlugin(),\n",
            after: "plugins: [\n"

          commit "installs and configures react-refresh + webpack plugin"
        end

        def enable_hmr
          gsub_file 'config/webpacker.yml', /    hmr: false/, '    hmr: true'
          commit "enables HMR in webpacker config"
        end

        def install_react_router
          run "yarn add react-router-dom react-router"
          route "get '*unmatched', to: 'application#index'\n"
          commit "installs react router and adds wildcard rails route to support rendering the app at unmatched routes"
        end
      end
    end
  end
end
