MapGame::Application.routes.draw do

  resources :games
  
  # -------------------------
  #   Custom Games
  # -------------------------
  match '/biggest_10_cities(/:id)' => 'games#biggest_10_cities', :as => :biggest_10_cities
  match '/validate_biggest_10_cities(/:id)' => 'games#validate_biggest_10_cities', :as => :validate_biggest_10_cities
  
 # resources :games do
 #   member do
 #     post 'validate_biggest_10_cities'
 #   end
 # end   
  
  root :to => "games#index"
end
