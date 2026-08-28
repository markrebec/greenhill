Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, only: [:sessions, :registrations, :passwords],
    controllers: { sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords" }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Rails' static file middleware serves public/index.html for real GET / traffic
  # before the router is ever consulted, in normal operation. This route is the
  # fallback for when it can't (see StaticController) — root always renders the
  # React app, not a placeholder — and it's also what root_path/root_url resolve
  # to (Devise calls them internally, e.g. as the sign-in/sign-out redirect
  # fallback).
  root to: 'static#index'
end
