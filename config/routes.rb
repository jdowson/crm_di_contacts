
ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|

    admin.resources :lookups, :collection => { :search => :get, :auto_complete => :post }, :member => { :unpublish => :put, :publish => :put, :inactivate => :put, :activate => :put, :confirm => :get }  do |lookup|

      lookup.resources :lookup_items, :as => "items", :collection => { :search => :get, :auto_complete => :post }, :member => { :unpublish => :put, :publish => :put, :inactivate => :put, :activate => :put, :confirm => :get,   :moveup => :put, :movedown => :put }

    end
    
#    admin.connect 'show_lookup_items/:lookup_id/:parent_id',
#              :controller => 'lookup_items',
#              :action     => 'show_lookup_items',
#	      :method     => :get
  end

end
