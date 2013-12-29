Expense::Application.routes.draw do
  resources :payments, only: [:index, :create]
  resource  :session,  only: [:new, :create, :destroy]

  resources :users, except: [:index, :show] do
    member do
      get :delete
    end
  end

  get "sign_out", to: "sessions#destroy"

  root to: "payments#index"
end
