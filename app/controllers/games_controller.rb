class GamesController < ApplicationController
  
  # --- Index
  def index
    @games = Game.all
  end    
  
  # --- Show
  def show
    @game = Game.find( params[:id] )
  end
    
  # ------------------------------
  # => CUSTOM Games
  # ------------------------------
  
  # --- name the 10 biggest cities in descending order
  #     @params: game.id, 
  def biggest_10_cities
    @game = Game.find( params[:id] )
    @cities = @game.cities.order( "population DESC" ).limit( 10 )
    @map = @game.map
  end
  
  
  # --- get the answere for the 10 Biggest cities
  #     @params: game.id, 
  def validate_biggest_10_cities
    @game = Game.find( params[:id] )
    cities = @game.cities.order( "population DESC" ).limit( 10 )
    result = Array.new

    (0..9).each do |index|
      city = cities[index]
      name = city.name.truncate(16)
      result.push({
        :result => (name == params[(index+1).to_s]),
        :population => city.population.humanize(0 ,'.'),
        :name => name})
    end        
    render :json => result
  end  
  
  
  # --- place 10 cities of a country on an empty map
  #     @params: game.id, 
  def empty_map
    @game = Game.find( params[:id] )
    @cities = @game.cities.order( "population DESC" ).limit( 10 )
    @map = @game.map    
  end
  
  
  # --- get the answere, and see how you put the cities at the right position
  #     @params: Cities[] "Berlin, Dresden, Hamburg"
  def validate_empty_map
    params[:cities].each do |city_name|
      cities = City.where( "name in ('Berlin')" )
      result = Array.new
      cities.each do |city|
        result.push({
            :title => city.name,
            :size => 10,
            :coord => [city.lon, city.lat]})
      end
    end
    render :json => result.to_json
  end
end
