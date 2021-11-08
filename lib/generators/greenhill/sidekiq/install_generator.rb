# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'
require 'greenhill/generators/commit_helper'

module Greenhill
  module Sidekiq
    module Generators
      class InstallGenerator < Rails::Generators::Base
        include Greenhill::Generators::CommitHelper

        desc "Configure and mount Sidekiq via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        def configure_sidekiq
          template 'sidekiq.rb', 'config/initializers/sidekiq.rb'
          template 'sidekiq.yml', 'config/sidekiq.yml'
          commit "adds default sidekiq configs"
        end

        def configure_active_job
          environment 'config.active_job.queue_adapter = :sidekiq'
          commit "configures active_job to use the sidekiq queue adapter"
        end

        def mount_sidekiq_web
          prepend_to_file 'config/routes.rb', "require 'sidekiq/web'\n"
          route <<-ROUTE
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end
ROUTE

          commit "mounts sidekiq web UI within admin namespace and wrapped in admin user auth"
        end
      end
    end
  end
end