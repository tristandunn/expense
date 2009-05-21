ActionController::Routing::Routes.draw do |map|
  map.resources :expenses, :collection => { :search => :get }
  map.resource  :session
  map.resources :users, :member => { :delete => :get }
  map.logout    'logout', :controller => 'sessions', :action => 'destroy'
  map.root      :controller => 'expenses'
end