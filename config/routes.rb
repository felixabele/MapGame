MapGame::Application.routes.draw do

  resources :games
  
  # -------------------------
  #   Custom Games
  # -------------------------
  match '/biggest_cities(/:id)' => 'games#biggest_cities', :as => :biggest_cities
  match '/validate_biggest_cities(/:id)' => 'games#validate_biggest_cities', :as => :validate_biggest_cities
  match '/empty_map(/:id)' => 'games#empty_map', :as => :empty_map  
  match '/validate_empty_map' => 'games#validate_empty_map', :as => :validate_empty_map
  
  root :to => "games#index"
end
