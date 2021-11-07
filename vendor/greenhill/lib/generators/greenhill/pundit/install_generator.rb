# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'

module Greenhill
  module Pundit
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc "Install Pundit with default policies via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        def install_pundit
          invoke "pundit:install"
        end

        def install_policies
          template 'authenticated_policy.rb', 'app/policies/authenticated_policy.rb'
          template 'admin_policy.rb', 'app/policies/admin_policy.rb'
          template 'public_policy.rb', 'app/policies/public_policy.rb'
        end
      end
    end
  end
end