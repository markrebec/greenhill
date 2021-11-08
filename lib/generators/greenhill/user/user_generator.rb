# TODO generate devise user
#      generate admin migration
#      generate policies (zuul?)
#      generate type (zuul?)
#      generate admin

# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/named_base'

module Greenhill
  module Generators
    class UserGenerator < Rails::Generators::NamedBase
      desc "Install and configure ActiveAdmin via Greenhill"
      source_root File.expand_path('../templates', __FILE__)

      def devise_user
        generate "devise #{name.singularize.classify}"
        inject_into_file 'app/models/user.rb',
          ",\n         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null",
          after: ":recoverable, :rememberable, :validatable"    
      end

      def admin_migration
        generate "migration add_admin_to_#{name.underscore.pluralize} admin:boolean"
      end

      def pundit_policies
        template 'policy.rb', "app/policies/#{name.singularize.underscore}_policy.rb"
        template 'admin_policy.rb', "app/policies/admin/#{name.singularize.underscore}_policy.rb"
      end

      def graphql_type
        generate "zuul:type #{name.singularize.classify} email:string admin:boolean reset_password_sent_at:datetime"
        inject_into_file "app/graphql/types/user_type.rb",
          "\n    pundit_role :admin_or_owner",
          after: "class UserType < Types::BaseObject"    
      end

      def admin_resource
        template 'admin.rb', "app/admin/#{name.underscore.pluralize}.rb"
      end

      def development_seeds
        append_to_file 'db/seeds.rb',
          "User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true) if Rails.env.development?"
      end
    end
  end
end
