# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Webpack
    module Generators
      class StorybookGenerator < Rails::Generators::Base
        include Greenhill::Generators::CommitHelper

        desc "Install and configure Storybook via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        def install_storybook
          run "yarn add @storybook/addon-actions @storybook/addon-essentials @storybook/addon-links @storybook/react babel-loader"
          directory 'storybook', '.storybook'
          run "npx --yes npm-add-script -k \"storybook\" -v \"start-storybook -p 6006\" --force"
          commit "installs and configures storybook with basic defaults"
        end

        def install_storyshots
          run "yarn add @storybook/addon-storyshots"
          template 'app/javascript/test/storyshots.test.ts'
          commit "installs storyshots and integrates with jest for storybook snapshots"
        end
      end
    end
  end
end
