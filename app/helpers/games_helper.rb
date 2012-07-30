module GamesHelper
  
  # =================================
  #   Helper for Map
  # =================================
  
  # --- Link to a Game
  def game_link(game, el)
    link_to( el, 
      {:action => game.category, :id => game}, 
      :title => game.name, :class => 'map_icon')
  end
  
  # --- Link to a Game with its Map as an Icon
  def game_icon_link(game)
    game_link( game, image_tag( "icons/#{game.map.country}.png" ) ) 
  end  
end
