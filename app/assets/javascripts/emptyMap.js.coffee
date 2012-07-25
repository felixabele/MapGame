# ============================================
# --- Game Classes
# ============================================ 
# Place Cities on an empty map
class EmptyMap
  constructor: (@output_el, @submit_el, @map_el) ->
    
    # SETTINGS
    @stack = {}
    @stack_count = 0
    @game_id = ''
    @stack_limit = 10
    @validation_action = '/validate_empty_map'
    @is_active = true
    @message_el = '.alert'
  
  # --- Set Game Id
  setGameId: (game_id) ->
    @game_id = game_id         
          
  # --- Get City-Names in stack
  getCityNames: ->  
    result = []
    for title, data of @stack
      result.push(title)  
    result
  
  # --- is the given city already in the stack
  cityIsInStack: (city_title) ->
    @stack[city_title]
  
     
  # ---------------------------------------------------
  # -- add the city to the stack or change the position
  # ---------------------------------------------------
  # @params: {title: 'berlin', coord:[11.1597,52.9991], pixel:[120,70]}
  addCity: (ref) -> 
    @stack_count++
    #$(@submit_el).removeClass 'disabled' if @stack_count is @stack_limit
    $(@submit_el).removeClass 'disabled'
    
    # insert into Stack
    @stack[ref.title] = ref

  updateCity: (ref) ->
    @stack[ref.title] = ref
     
  # ---------------------------------------------------  
  # --- Submit Game (only if game is still active)
  # ---------------------------------------------------
  submit: ->  
    if @is_active
      $.ajax 
        url: "#{@validation_action}"
        type: 'POST'
        dataType: 'json'
        data: 
          cities: @getCityNames()
        error: (jqXHR, textStatus, errorThrown) ->
          console.log "Validtion failed: #{textStatus}"
        success: (data, textStatus, jqXHR) =>
          @validate( data )

  # Validate with Data from Database
  validate: (results) ->  
    
    map_el = $( @map_el ).data( 'geocloud' )
    put_el = $( @output_el )
  
    # Options for the correct location
    opt = attr: {class: 'correct_location'}
      
    count = 0  
    for corr_city in results
      count++
      city_name = corr_city.title
      corr_city.title = count      
      map_el.drawPoint( corr_city, opt )
      distance = map_el.drawLine( corr_city, @stack[city_name] )
            
      console.log "#{distance}"
      
# ---------------------------------------------    

# Add Class to global context
window.EmptyMap = EmptyMap