# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/named_base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Generators
    class UserGenerator < Rails::Generators::NamedBase
      include Greenhill::Generators::CommitHelper

      desc "Install and configure ActiveAdmin via Greenhill"
      source_root File.expand_path('../templates', __FILE__)

      # TODO replace all these with singular_name/plural_name
      def devise_user
        generate "devise #{name.singularize.classify}"
        commit "runs devise #{name.singularize.classify} generator"
      end

      def enable_jwt
        inject_into_file "app/models/#{name.singularize.underscore}.rb",
          ",\n         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null\n",
          after: ":recoverable, :rememberable, :validatable"
        inject_into_file "app/models/#{name.singularize.underscore}.rb",
          "\n  self.skip_session_storage = [:http_auth, :params_auth]\n",
          after: ":jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null\n"

        commit "enables JWT authentication for #{name.singularize.underscore}"
      end

      def admin_migration
        generate "migration add_type_to_#{name.pluralize.underscore} type:string:index"
        template "app/models/admin_user.rb", "app/models/admin_#{name.singularize.underscore}.rb"
        inject_into_file "app/models/#{name.singularize.underscore}.rb",
          after: "self.skip_session_storage = [:http_auth, :params_auth]\n" do <<-ADMIN
  def admin?
    false
  end
ADMIN
        end
        commit "adds a type field and AdminUser model to enable STI for users/admins"
      end

      def pundit_policies
        template 'policy.rb', "app/policies/#{name.singularize.underscore}_policy.rb"
        template 'admin_policy.rb', "app/policies/admin/#{name.singularize.underscore}_policy.rb"
        commit "adds default policies for #{name.pluralize.underscore}"
      end

      def devise_controllers
        directory 'app/controllers/users'
        directory 'app/controllers/admin'
        directory 'app/views/admin'
        gsub_file 'config/routes.rb', /devise_for :users/, "devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }, defaults: { format: :json }\n  devise_for :admin, class_name: 'AdminUser', only: :sessions, controllers: { sessions: 'admin/sessions' }"
        commit "customizes devise sessions and registrations controllers to better work with the SPA/JWT auth flow"
      end

      def graphql_type
        generate "zuul:type #{name.singularize.classify} email:string admin:boolean reset_password_sent_at:datetime"
        inject_into_file "app/graphql/types/#{name.singularize.underscore}_type.rb",
          "\n    pundit_role :admin_or_owner",
          after: "class #{name.singularize.classify}Type < Types::BaseObject"
          commit "generates graphql type for #{name.pluralize.underscore}"
      end

      def admin_resource
        template 'admin.rb', "app/admin/#{name.pluralize.underscore}.rb"
        commit "adds basic admin resource for #{name.pluralize.underscore}"
      end

      def development_seeds
        append_to_file 'db/seeds.rb',
          "Admin#{name.singularize.classify}.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?"
        commit "seeds a development-only Admin#{name.singularize.underscore} account"
      end
    end
  end
end
