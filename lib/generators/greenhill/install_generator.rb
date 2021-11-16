# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Greenhill::Generators::CommitHelper

      desc "Install and configure boilerplate application via Greenhill"
      source_root File.expand_path('../templates', __FILE__)

      def todo_rename_me_pre_setup
        template 'config/initializers/mini_profiler.rb'
        commit "configures rack mini profiler"
      end

      def todo_rename_me_install_generators
        generate 'greenhill:webpack:typescript'
        generate 'greenhill:webpack:react'
        generate 'greenhill:webpack:jest'
        generate 'greenhill:webpack:eslint'
        generate 'greenhill:webpack:storybook'
        generate 'greenhill:webpack:styled'
        generate 'greenhill:webpack:boilerplate'
        # TODO any additional loaders: icons, css, url, etc.
        # TODO axios, react-router, (react-query / apollo)
        # TODO finish cleaning up and standardize generator templates (.tt vs not)
        # TODO reorganize and clean up theme primitives in a way that's more customizable
      
        generate 'rspec:install'
        prepend_to_file 'spec/spec_helper.rb', <<-COVERAGE
        # Load and launch SimpleCov at the very top of your spec_helper.rb
        # SimpleCov.start must be issued before any of your application code is required
        # See https://github.com/simplecov-ruby/simplecov#getting-started
        require 'simplecov'
        SimpleCov.start\n
      COVERAGE
        commit "runs rspec install generator and configures with simplecov"
      
        generate 'greenhill:sidekiq:install'
        generate 'greenhill:devise:install'
        generate 'greenhill:pundit:install'
        generate 'greenhill:graphql:install'
        generate "greenhill:admin:install"
      
        generate "zuul:install"
        commit "runs zuul:install generator"
      
        # TODO specs / factories
        generate 'greenhill:user User'
      end
    end
  end
end
