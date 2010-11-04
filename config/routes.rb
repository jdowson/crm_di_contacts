
ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|

    admin.resources :lookups, :collection => { :search => :get, :auto_complete => :post }, :member => { :unpublish => :put, :publish => :put, :inactivate => :put, :activate => :put, :confirm => :get }

    admin.resources :lookup_items, :collection => { :search => :get, :auto_complete => :post }, :member => { :unpublish => :put, :publish => :put, :inactivate => :put, :activate => :put, :confirm => :get,   :moveup => :put, :movedown => :put }

  end

end
