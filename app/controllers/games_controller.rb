class GamesController < ApplicationController
  
  # --- Index
  def index
    @game_cat = params[:cat]

    # Index-View with all Options
    if @game_cat.nil?
      @games = {
        :biggest_cities => Game.find_all_by_category( 'biggest_cities' ),
        :empty_map => Game.find_all_by_category( 'empty_map' )}

    # Overview of the selected category  
    else
      @games = Game.find_all_by_category( @game_cat )    
    end
  end
  
  # ------------------------------
  # => CUSTOM Games
  # ------------------------------
  
  # --- name the 10 biggest cities in descending order
  #     @params: game.id, 
  def biggest_cities
    @game = Game.find( params[:id] )
    @cities = @game.cities.order( "population DESC" ).limit( 10 )
    @map = @game.map
  end
  
  
  # --- get the answere for the 10 Biggest cities
  #     @params (POST): game.id, 
  #              1=Leipzig&2=Berlin&3=Bremen&4=Hamburg
  def validate_biggest_cities
    @game = Game.find( params[:id] )
    
    # get Valid Cities from DB
    valid_cities = @game.cities.get_by_name_array(params[:cities])
    result = Array.new
    
    #p params
    posi = 0
    valid_cities.each do |valid_city|
      
      given_city = params[:cities][posi]
      name = valid_city.name.truncate(16)
      
      result.push({
        :result => (name == given_city),
        :population => valid_city.population.humanize(0 ,'.'),
        :name => name})
      posi += 1
    end
    render :json => result
  end  
  
  
  # --- place 10 cities of a country on an empty map
  #     @params: game.id, random (true,false) 
  def empty_map
    @game = Game.find( params[:id] )
    
    # if flag random is active load 10 Cities radomly
    if params[:random]
      @cities = @game.cities.random
    
   # else: just get the biggest 10 Cities   
    else
      @cities = @game.cities.biggest
    end    
    @map = @game.map    
  end
  
  
  # --- get the answere, and see how you put the cities at the right position
  #     @params: Cities[] "Berlin, Dresden, Hamburg"
  def validate_empty_map
    result = Array.new
    unless params[:cities].nil?
      params[:cities].each do |city_name|
        city = City.find_by_name( city_name )
        result.push({
            :title => city.name,
            :size => 10,
            :coord => [city.lon, city.lat]})
      end
    end
    render :json => result.to_json
  end
end
