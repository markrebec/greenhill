# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'

module Greenhill
  module Admin
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc "Install and configure ActiveAdmin via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        class_option :use_webpacker, type: :boolean, default: false, desc: "Use Webpacker assets instead of Sprockets"

        def install_active_admin
          generate "active_admin:install --skip-users #{options['use_webpacker'] ? '--use-webpacker' : ''}"
        end

        def configure_active_admin
          gsub_file 'config/initializers/active_admin.rb', /# config\.authentication_method = :authenticate_admin_user!/, 'config.authentication_method = :authenticate_user!'
          gsub_file 'config/initializers/active_admin.rb', /# config\.authorization_adapter = ActiveAdmin::CanCanAdapter/, 'config.authorization_adapter = ActiveAdmin::PunditAdapter'
          gsub_file 'config/initializers/active_admin.rb', /# config\.pundit_default_policy = "MyDefaultPunditPolicy"/, 'config.pundit_default_policy = "AdminPolicy"'
          gsub_file 'config/initializers/active_admin.rb', /# config\.pundit_policy_namespace = :admin/, 'config.pundit_policy_namespace = :admin'
          gsub_file 'config/initializers/active_admin.rb', /# config\.current_user_method = :current_admin_user/, 'config.current_user_method = :current_user'
          gsub_file 'config/initializers/active_admin.rb', /config\.logout_link_path = :destroy_admin_user_session_path/, 'config.logout_link_path = :destroy_user_session_path'
          gsub_file 'config/initializers/active_admin.rb', /# config\.logout_link_method = :get/, 'config.logout_link_method = :delete'
          inject_into_file 'config/initializers/active_admin.rb', before: '  # == Download Links' do <<-NAVIGATION

  config.namespace :admin do |admin|
    admin.build_menu :default do |menu|
      menu.add label: "Sidekiq", url: "/admin/sidekiq", html_options: { target: :_blank }
      menu.add label: "GraphQL", url: "/admin/graphiql", html_options: { target: :_blank }
    end
  end

NAVIGATION
          end
        end
      end
    end
  end
end
