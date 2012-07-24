# ============================================
# --- Game Classes
# ============================================ 
# Place Cities on an empty map
class EmptyMap
  constructor: (@output_el, @submit_el) ->
    
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
     
  # ---------------------------------------------------
  # -- add the city to the stack or change the position
  # ---------------------------------------------------
  # @params: {title: 'berlin', coord:[11.1597,52.9991], pixel:[120,70]}
  addOrMoveCity: (ref) -> 
  
    # increment counter on insert, if all cities are placed enable submit button    
    @stack_count++ if not @stack[ref.title]    
    #$(@submit_el).removeClass 'disabled' if @stack_count is @stack_limit
    $(@submit_el).removeClass 'disabled'
    
    # Update Stack
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
          console.log data

  # Validate with Data from Database
  validate: (results) ->  
  
# ---------------------------------------------    

# Add Class to global context
window.EmptyMap = EmptyMap
