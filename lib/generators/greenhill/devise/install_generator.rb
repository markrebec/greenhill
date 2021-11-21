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
        source_root File.expand_path('../templates', __FILE__)

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

        def configure_responders
          template 'lib/auth_json_failure_app.rb'
          template 'lib/responders/auth_json_responder.rb'
          prepend_to_file 'config/initializers/devise.rb', "require 'auth_json_failure_app'\n"
          inject_into_file 'config/initializers/devise.rb',
            before: "  # ==> Configure JWT for :jwt_authenticatable\n" do <<-DEVISE
  # ==> Configure Warden with custom failure app
  # Configure the failure app used by Warden to respond to failed authentication
  # requests with a JSON payload containing status and errors.
  config.warden do |manager|
    manager.failure_app = AuthJsonFailureApp
  end

DEVISE
          end
          commit "configures devise/warden with custom responders for json auth"
        end
      end
    end
  end
end
