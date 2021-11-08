# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Pundit
    module Generators
      class InstallGenerator < Rails::Generators::Base
        include Greenhill::Generators::CommitHelper

        desc "Install Pundit with default policies via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        def install_pundit
          invoke "pundit:install"
          commit "runs pundit:install generator"
        end

        def install_policies
          template 'authenticated_policy.rb', 'app/policies/authenticated_policy.rb'
          template 'admin_policy.rb', 'app/policies/admin_policy.rb'
          template 'public_policy.rb', 'app/policies/public_policy.rb'
          commit "adds default pundit policies"
        end
      end
    end
  end
end