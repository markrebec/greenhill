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
          run "yarn add -D styled-components babel-plugin-styled-components @types/styled-components"
          inject_into_file 'babel.config.js', "      'babel-plugin-styled-components',\n", after: "'@babel/plugin-transform-destructuring',\n"
          commit "installs styled-components and the babel plugin"
        end

        def install_styled_system
        end
      end
    end
  end
end
