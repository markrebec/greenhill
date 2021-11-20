# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Devise
    module Generators
      class InstallGenerator < Rails::Generators::Base
        include Greenhill::Generators::CommitHelper

        desc "Install Devise with JWT support via Greenhill"

        def install_devise
          generate 'devise:install'
          commit "runs devise:install generator"
        end

        def configure_jwt
          inject_into_file 'config/initializers/devise.rb',
            before: "  # ==> Controller configuration\n" do <<-DEVISE
  # ==> Configure JWT for :jwt_authenticatable
  # Configure the secret key used when using JWT for authentication. This should
  # be a different value than your secret_key/secret_key_base above.
  config.jwt do |jwt|
    jwt.secret = ENV.fetch('JWT_SECRET')
    jwt.dispatch_requests = [
      ['POST', %r{^/graphql$}]
    ]
  end

DEVISE
          end
          commit "configures devise with jwt secret key via env vars and reissues tokens on graphql requests"
        end
      end
    end
  end
end
