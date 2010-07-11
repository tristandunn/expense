Expense::Application.routes.draw do |map|
  resources :payments
  resource  :session

  resources :users do
    member do
      get :delete
    end
  end

  match 'sign_out' => 'sessions#destroy'

  root  :to => 'payments#index'
end
