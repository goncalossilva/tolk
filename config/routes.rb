ActionController::Routing::Routes.draw do |map|
  map.namespace('tolk') do |tolk|
    tolk.root :controller => 'locales'
    tolk.resources :locales, :member => {:all => :get, :updated => :get, :export => :get, :import => :post}
    tolk.resource :search
  end
end
