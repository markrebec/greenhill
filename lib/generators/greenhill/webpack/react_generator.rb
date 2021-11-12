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
          gsub_file 'babel.config.js', /      isProductionEnv && \[\n        'babel-plugin-transform-react-remove-prop-types',\n        {\n          removeImport: true\n        }\n      \]/, ''
          commit "removes prop-types and moves babel react preset to dev dependencies"
        end


        ##########################
        # TODO move this (and other app-related stuff) to a BoilerplateGenerator
        ##########################

        def temp_controller_and_view
          inject_into_file 'app/controllers/application_controller.rb', before: /end[\n]*\Z/ do <<-ACTION
  def index
  end
ACTION
          end
          create_file 'app/views/application/index.html.erb', '<div id="root"></div>'
          route "root to: 'application#index'"
          commit "WIP TEMP adds basic index action, route and view to render the react app"
        end

        def temp_application_pack
          remove_file 'app/javascript/packs/hello_react.jsx'
          directory 'app/javascript/components'
          insert_into_file 'app/javascript/packs/application.js' do <<-REACT
import React from 'react'
import ReactDOM from 'react-dom'
import Application from 'components/Application'

document.addEventListener('DOMContentLoaded', (): void => {
  ReactDOM.render(
    <Application />,
    document.body.appendChild(document.createElement('div')),
  )
})
REACT
          end
          run 'mv app/javascript/packs/application.js app/javascript/packs/application.tsx'
          commit "WIP TEMP placeholder application templates"
        end
      end
    end
  end
end
