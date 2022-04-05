Rails.application.routes.draw do
  resources :users do
    collection do
      get :user_info, defaults: {format: :json}
    end
  end

  resources :resource_clicks, defaults: {format: :json}

  # devise_config = ActiveAdmin::Devise.config
  # devise_config[:controllers][:omniauth_callbacks] = 'omniauth_callbacks'
  devise_for :users, path: "/admin", controllers: {omniauth_callbacks: "omniauth_callbacks"}
  ActiveAdmin.routes(self)

  get "/admin/logout" => "admin/sessions#logout"

  get '/monit'  => "monitor#index"

  root to: redirect("/admin")
end
