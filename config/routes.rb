require "sidekiq/web"
require "sidekiq_unique_jobs/web"
require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, only: [:sessions, :registrations, :passwords, :confirmations, :unlocks],
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      passwords: "users/passwords",
      confirmations: "users/confirmations",
      unlocks: "users/unlocks",
    }

  # GraphiQL — gated behind an AdminUser session (linked from ActiveAdmin's
  # "Engineering" menu, see config/initializers/active_admin.rb). Querying
  # most fields (e.g. `me`) also needs a signed-in User in the same browser,
  # since the schema resolves off that session, not the admin one.
  authenticate :admin_user do
    mount GraphiQL::Rails::Engine, at: "/admin/graphiql", graphql_path: "/graphql"
    mount Sidekiq::Web => "/admin/sidekiq"
    mount Flipper::UI.app(Flipper) => "/admin/flipper"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Renders the React app shell (see StaticController) — vite_javascript_tag in
  # the layout points at the Vite dev server or the built manifest as needed.
  root to: 'static#index'

  # Catch-all for client-side routing (React Router) — anything that didn't
  # match a real route above falls through to the same app shell. Must stay
  # last so it never shadows /graphql, /admin/*, /users/*, /up, etc.
  get "*path", to: "static#index"
end
