Rails.application.routes.draw do
  root to: "static#show", page: "home"

  get "/page/:page" => "static#show"
  resources :people, only: [:index, :show, :destroy] do
    get 'update_groups', on: :member
    get 'import_from_directory', on: :member
  end
  resources :groups, only: [:index, :show] do
    get 'update_members', on: :member
  end

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:edit, :update]
  end
  
  namespace :gwd do
    resources :users
    resources :groups
    resources :email_contacts
  end

  get "/sign_in" => "clearance/sessions#new", :as => "sign_in"
  # Override SessionsController to change URL after sign out on #destroy
  delete "/sign_out" => "sessions#destroy", :as => "sign_out"
  get "/sign_up" => "clearance/users#new", :as => "sign_up"
  get "/confirm_email/:token" => "email_confirmations#update", :as => "confirm_email"
end
