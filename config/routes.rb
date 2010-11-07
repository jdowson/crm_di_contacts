
ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|

    admin.resources :lookups, :collection => { :search => :get, :auto_complete => :post }, :member => { :unpublish => :put, :publish => :put, :inactivate => :put, :activate => :put, :confirm => :get }, :except => :show, :requirements => { :lookup_id => nil }  do |lookup|

      lookup.resources :lookups, :name_prefix => "admin_child_", :as => "children", :collection => { :search => :get, :auto_complete => :post }, :member => { :unpublish => :put, :publish => :put, :inactivate => :put, :activate => :put, :confirm => :get,   :moveup => :put, :movedown => :put }, :except => :show

      lookup.resources :lookup_items, :name_prefix => "admin_", :as => "items", :collection => { :search => :get, :auto_complete => :post }, :member => { :unpublish => :put, :publish => :put, :inactivate => :put, :activate => :put, :confirm => :get,   :moveup => :put, :movedown => :put }, :requirements => { :lookup_item_id => nil }, :except => :show do |item|

        item.resources :lookup_items, :name_prefix => "admin_child_", :as => "children", :collection => { :search => :get, :auto_complete => :post }, :member => { :unpublish => :put, :publish => :put, :inactivate => :put, :activate => :put, :confirm => :get,   :moveup => :put, :movedown => :put }, :except => :show
	  
      end

    end
    
  end

end
