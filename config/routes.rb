Expense::Application.routes.draw do |map|
  resources :payments do
    collection do
      get :search
    end
  end

  resource :session

  resources :users do
    member do
      get :delete
    end
  end

  match 'logout' => 'sessions#destroy'

  root  :to => 'payments#index'
end
