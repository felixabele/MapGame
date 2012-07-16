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
  def biggest_10_cities
    @game = Game.find( params[:id] )
    @cities = @game.cities.order( "population DESC" ).limit( 10 )
    @map = @game.map
  end
  
  # get the answere
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
end
