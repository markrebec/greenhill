# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Webpack
    module Generators
      class BoilerplateGenerator < Rails::Generators::Base
        include Greenhill::Generators::CommitHelper

        desc "Adds boilerplate application structure for Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        def temp_controller_and_view
          inject_into_file 'app/controllers/application_controller.rb', before: /end[\n]*\Z/ do <<-ACTION
  def index
  end
ACTION
          end
          create_file 'app/views/application/index.html.erb', '<div id="root"></div>'
          route "root to: 'application#index'\n"
          commit "WIP TEMP adds basic index action, route and view to render the react app"
        end

        def temp_application_pack
          remove_file 'app/javascript/packs/hello_react.jsx'
          directory 'app/javascript/components'
          directory 'app/javascript/compositions'
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
