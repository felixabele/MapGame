#= require biggestCities

# ============ COFFEE-SCRIPT FOR GAMES ================= #
# -- Map specific Options
map_opt = 
  css: ''
  attr: 
    class: 'city'
  events:
    mouseover: hover_city = (event) ->
      hover_city( event )
    click: click_city = (event) ->
      click_city $( event.currentTarget )      
 
 # INIT game
 game = new BiggestCities('#output', '#btn_submit', '#btn_clear')


# ============================================
# --- Page Init
# ============================================
$(document).ready -> 
  map_element = $( '.geo_map' )
  
  if map_element.length > 0
    game_id = map_element.data( 'game_id' )
    map = map_element.data( 'map' )
    cities = eval( map_element.data( 'cities' ) )
    
    # Draw the map
    map_element.geocloud(map)
    
    # Add Cities to the map
    for city in cities
      city_el = map_element.data( 'geocloud' ).drawPoint( city, map_opt )
      city_el.append "<span class='place'></span><span class='city_name'>#{city.title}</span>"
      
    game.setGameId game_id 
      
    # --- Listener
    $('#btn_submit').click -> 
      if game.is_active
        game.submit() if not $(@).hasClass 'disabled'
        false
      
    $('#btn_clear').click ->    
      if game.is_active
        game.reset()

        # Clear all selected Cities
        map_element.find( '.selected' ).each ->
          $(@).find( '.place' ).html ''
          $(@).removeClass 'selected' 
        false
      


# --------------------------------------------
# --- Hover over a City
# --------------------------------------------
hover_city = (event) ->

# --------------------------------------------
# --- Click a City
# --------------------------------------------
#   @params: city (point on the map) (DOM-Element)
click_city = ( city ) ->
  if game.is_active
    if city.hasClass 'selected'    
      game.removeCity city.data( 'place' )
      city.find('.place').html ''
      city.removeClass 'selected'
    else
      index = game.addCity city.attr( 'title' )
      city.find('.place').append index
      city.data 'place', index    
      city.addClass 'selected'