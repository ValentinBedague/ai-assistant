Rails.application.routes.draw do
  devise_for :users
  root to: "recipes#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :recipes, only: [:index, :new, :create, :show] do
    collection do
      get :new_via_img
      post :create_via_img

      get :new_via_url
      post :create_via_url
    end
    member do
      patch :reset_recipe
    end
    resources :messages, only: [:index] do
      collection do
        get :edit_portions
        post :run_edit_portions

        get :edit_ingredients
        post :run_edit_ingredients

        post :run_low_calories

        get :chat
        post :run_chat
      end
    end
    resources :chats, only: [:index, :create]
  end

  resources :chats, only: :show do
    resources :chat_messages, only: [:create]
  end
end
