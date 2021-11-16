# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Webpack
    module Generators
      class EslintGenerator < Rails::Generators::Base
        include Greenhill::Generators::CommitHelper

        desc "Install and configure eslint via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        def install_eslint
          run "yarn add eslint eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-import eslint-plugin-jsx-a11y @typescript-eslint/eslint-plugin @typescript-eslint/parser"
          template 'eslint.json', '.eslintrc.json'
          run "npx --yes npm-add-script -k \"lint\" -v \"tsc && eslint ./app/javascript\" --force"
          commit "installs and configures eslint for typescript and react"
        end
      end
    end
  end
end
