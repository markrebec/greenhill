# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Webpack
    module Generators
      class StyledGenerator < Rails::Generators::Base
        include Greenhill::Generators::CommitHelper

        desc "Install and configure styled-components and styled-system via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        def install_styled_components
          run "yarn add styled-components babel-plugin-styled-components @types/styled-components"
          inject_into_file 'babel.config.js', "      'babel-plugin-styled-components',\n", after: "'@babel/plugin-transform-destructuring',\n"
          commit "installs styled-components and the babel plugin"
        end

        def install_styled_system
          run "yarn add styled-system @types/styled-system csstype"
          commit "installs styled-system and csstype for theming"
        end

        # TODO this should probably actually live inside greenhill itself and provde overridable theming
        # TODO and/or maybe move this into /app/javascript/theme instead of the root path
        def init_primitives_and_constants
          directory 'app/javascript/theme'
          directory 'app/javascript/stories' # TODO move this to storybook, and just add the palette stories template here?
          commit "installs theme primitives and constants"
        end

        def disable_sprockets_stylesheet
          gsub_file 'app/views/layouts/application.html.erb', /<%= stylesheet_link_tag/, '<%#= stylesheet_link_tag'
          commit "disables sprockets stylesheet by default"
        end
      end
    end
  end
end
