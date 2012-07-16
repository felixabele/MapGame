#= require biggestCities

# ============ COFFEE-SCRIPT FOR GAMES ================= #

# -- Map specific Data
map_data = 
  germany:
    width: 304
    height: 400
    map_src: '/assets/maps/germany_s.gif'
    ref_point:
      pixel_point: [137, 215], coord: [9.92968989, 51.538352]
    geo_settings:  
      x_corr: 0.76, y_corr: 1.22, coef: 0.0240139

  spain:
    width: 482
    height: 400
    map_src: '/assets/maps/spain_s.gif'
    ref_point:
      pixel_point: [235, 246], coord: [-3.7003454, 40.4166909]
    geo_settings:  
      x_corr: 0.81, y_corr: 1.04, coef: 0.0281
      
  italy:
    width: 306
    height: 400
    map_src: '/assets/maps/italy_s.gif'
    ref_point:
      pixel_point: [149, 208], coord: [12.4942486, 41.8905198]
    geo_settings:  
      x_corr: 0.81, y_corr: 1.10, coef: 0.0316  

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
    country = map_element.data( 'country' )
    cities = map_element.data( 'cities' )
    cities = eval( cities )
    
    # Draw the map
    map_element.geocloud(map_data[country])
    
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