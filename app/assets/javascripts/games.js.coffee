# ============ COFFEE-SCRIPT FOR GAMES ================= #

# ============================================
# --- 10 Biggest Cities
# ============================================
$(document).bind 'biggest_cities_games.load', (e,obj) =>
  console.log "Load Events for Action: biggest_cities"
  
  #= require biggestCities
  
  # -- Map specific Options
  map_opt = 
    css: ''
    attr: 
      class: 'city'
    events:
      mouseenter: ->
        $(@).addClass "marked"
      mouseleave: ->
        $(@).removeClass "marked"
      click: click_city = (event) ->
        click_city $( event.currentTarget )      

  # INIT game
  game = new BiggestCities('#output', '#btn_submit', '#btn_clear')

  # --- Page Init
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

  # --- Click a City
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
        
        

# ============================================
# --- empty_map
# ============================================        
$(document).bind 'empty_map_games.load', (e,obj) => 
  console.log "Load Events for Action: empty_map"

  #= require emptyMap

  # Init Map
  map_element = $( '.geo_map' )
  map_posi = map_element.position()
  map = map_element.data( 'map' )

  # INIT game
  game = new EmptyMap('#output', '#btn_submit', '.geo_map')

  # Draw the map
  map.use_canvas = true
  map_element.geocloud(map)

  # -----------------------------
  #   DRAG'n'DROP
  # -----------------------------
  # Drag a City
  $( ".geo_cloud div" ).draggable
    revert: 'invalid'    
  
  # And drop it somewhere on the Map
  $( ".geo_map" ).droppable
    drop: ( event, ui ) -> 
      city_name = ui.draggable.find('.city_name').html()
      drag_posi = ui.draggable.position()      
      map_el = $(@)
      
      if game.cityIsInStack( city_name )          
          
        # update position
        game.updateCity
          title: city_name
          pixel_point: [drag_posi.left, drag_posi.top]
          coord: map_element.data( 'geocloud' ).pixelsToCoords( [drag_posi.left, map_el.height()-drag_posi.top] )          
        
      else 
        rel_top  = drag_posi.top-map_posi.top
        rel_left = drag_posi.left-map_posi.left
        rel_bott = map_el.height()-rel_top
        
        ui.draggable.removeClass( 'raw_point' ).addClass( 'dragged_point' ) 
        ui.draggable.appendTo( map_el )
        ui.draggable.css 
          top: rel_top-5
          left: rel_left-10
          position: 'absolute'

        # Add City
        game.addCity 
          title: city_name
          pixel_point: [rel_left, rel_top]
          coord: map_element.data( 'geocloud' ).pixelsToCoords( [rel_left, rel_bott] )
          
  # -----------------------------
  #   SUBMIT
  # -----------------------------
  $('#btn_submit').click -> 
    if game.is_active and game.stackIsFull()
      game.submit()
      $( ".geo_cloud div" ).draggable( 'disable' )
      $(@).addClass 'disabled'
      false
      