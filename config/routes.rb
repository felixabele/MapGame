MapGame::Application.routes.draw do

  resources :games
  
  # -------------------------
  #   Custom Games
  # -------------------------
  match '/biggest_10_cities(/:id)' => 'games#biggest_10_cities', :as => :biggest_10_cities
  match '/validate_biggest_10_cities(/:id)' => 'games#validate_biggest_10_cities', :as => :validate_biggest_10_cities
  match '/empty_map(/:id)' => 'games#empty_map', :as => :empty_map  
  match '/validate_empty_map' => 'games#validate_empty_map', :as => :validate_empty_map
  
 # resources :games do
 #   member do
 #     post 'validate_biggest_10_cities'
 #   end
 # end   
  
  root :to => "games#index"
end
