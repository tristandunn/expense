ActionController::Routing::Routes.draw do |map|
  map.resource  :session
  map.resources :users, :member => { :delete => :get }
end