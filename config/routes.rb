Expense::Application.routes.draw do |map|
  resources :payments, :only => [:index, :new, :create]
  resource  :session,  :only => [:new, :create, :destroy]

  resources :users, :except => [:index, :show] do
    member do
      get :delete
    end
  end

  match 'sign_out' => 'sessions#destroy'

  root  :to => 'payments#index'
end
