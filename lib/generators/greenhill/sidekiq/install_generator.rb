# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/base'

module Greenhill
  module Sidekiq
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc "Configure and mount Sidekiq via Greenhill"
        source_root File.expand_path('../templates', __FILE__)

        def install_sidekiq
          environment 'config.active_job.queue_adapter = :sidekiq'
          template 'sidekiq.rb', 'config/initializers/sidekiq.rb'
          template 'sidekiq.yml', 'config/sidekiq.yml'
        end

        def mount_sidekiq_web
          prepend_to_file 'config/routes.rb', "require 'sidekiq/web'\n"
          route <<-ROUTE
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end
ROUTE
        end
      end
    end
  end
end