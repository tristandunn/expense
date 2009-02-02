ActionController::Routing::Routes.draw do |map|
  map.resources :expenses
  map.resource  :session
  map.resources :users, :member => { :delete => :get }
  map.root      :controller => 'expenses'
end