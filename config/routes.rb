
#ActionController::Routing::Routes.draw do |map|
#  map.resourses :businesspartners, :controller => :businessPartners
#end

ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resources :lookups, :collection => { :search => :get, :auto_complete => :post }, :member => { :unpublish => :put, :publish => :put, :inactivate => :put, :activate => :put, :confirm => :get }
  end
end

#ActionController::Routing::Routes.draw do |map|
#  map.businessPartners
#end