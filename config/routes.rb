
ActionController::Routing::Routes.draw do |map|

  map.match   'messagebox/:caption/:icon/*buttons', :controller => 'messagebox', :action => 'show'
  
  map.namespace :admin do |admin|

    admin.resources :lookups, :collection => { :search => :get, :auto_complete => :post }, :member => { :unpublish => :put, :publish => :put, :inactivate => :put, :activate => :put, :confirm => :get, :update_cache => :put }, :except => :show, :requirements => { :lookup_id => nil }  do |lookup|

      lookup.resources :lookups, :name_prefix => "admin_child_", :as => "children", :collection => { :search => :get, :auto_complete => :post }, :member => { :unpublish => :put, :publish => :put, :inactivate => :put, :activate => :put, :confirm => :get, :update_cache => :put }, :except => :show

      lookup.resources :lookup_items, :name_prefix => "admin_", :as => "items", :collection => { :auto_complete => :post, :publish_all => :put, :sort_a_z_description => :put, :sort_a_z_code => :put }, :member => { :unpublish => :put, :publish => :put, :inactivate => :put, :activate => :put, :confirm => :get,   :moveup => :put, :movedown => :put }, :requirements => { :lookup_item_id => nil }, :except => :show do |item|

        item.resources :lookup_items, :name_prefix => "admin_child_", :as => "children", :collection => { :auto_complete => :post, :publish_all => :put, :sort_a_z_description => :put, :sort_a_z_code => :put }, :member => { :unpublish => :put, :publish => :put, :inactivate => :put, :activate => :put, :confirm => :get,   :moveup => :put, :movedown => :put }, :except => :show
	  
      end

    end
    
  end

end
