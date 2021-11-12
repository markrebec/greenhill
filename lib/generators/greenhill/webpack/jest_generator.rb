# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Webpack
    module Generators
      class JestGenerator < Rails::Generators::Base
        include Greenhill::Generators::CommitHelper

        desc "Install and configure jest via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        def install_jest
          run "yarn add -D jest @types/jest babel-jest"
          template 'jest.config.ts'
          run "npx --yes npm-add-script -k \"test\" -v \"jest\" --force"
          insert_into_file '.gitignore', 'app/javascript/coverage'
          commit "installs and configures jest"
        end

        def install_react_testing_library
          run "yarn add -D @testing-library/jest-dom @testing-library/react @types/testing-library__jest-dom"
          template 'app/javascript/test/utils.tsx'
          commit "installs and configures testing-library packages for jest and react"
        end
      end
    end
  end
end
