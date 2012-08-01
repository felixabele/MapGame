# ============================================
# --- Game Classes
# ============================================ 
# Place Cities on an empty map
class EmptyMap
  constructor: (@output_el, @submit_el, @map_el) ->
    
    # SETTINGS
    @stack = {}
    @stack_count = 0
    @stack_limit = 10
    @validation_action = '/validate_empty_map'
    @is_active = true
    @message_el = '.alert'
     
  # --- Get City-Names in stack
  getCityNames: ->  
    result = []
    for title, data of @stack
      result.push(title)  
    result
  
  # --- is the given city already in the stack
  cityIsInStack: (city_title) ->
    @stack[city_title]
  
     
  # --- Is the GAmes Stack full ?
  stackIsFull: ->
    @stack_limit is @stack_count  
     
  # ---------------------------------------------------
  # -- add the city to the stack or change the position
  # ---------------------------------------------------
  
  # --- Insert into city-stack
  # @params: {title: 'berlin', coord:[11.1597,52.9991], pixel:[120,70]}  
  addCity: (ref) -> 
    @stack_count++
    $( @submit_el ).removeClass 'disabled' if @stack_count is @stack_limit    
    
    # insert into Stack
    @stack[ref.title] = ref

  # --- Update city-stack
  updateCity: (ref) ->
    @stack[ref.title] = ref
     
  # ---------------------------------------------------  
  # --- Submit and validate Game (only if game is still active)
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
          @is_active = false          

  # --- Validate with Data from Database
  validate: (results) ->  
    
    map_el = $( @map_el ).data( 'geocloud' )
    out_el = $( @output_el )
    msg_out = $( @message_el )
    distance_sum = 0
  
    # Options for the correct location
    opt = attr: {class: 'correct_location'}
      
    count = 0  
    for corr_city in results
      count++
      city_name = corr_city.title
      corr_city.title = "#{city_name} (korrekt)"      
      map_el.drawPoint( corr_city, opt )
      
      distance = map_el.drawLine( corr_city, @stack[city_name] )                        
      distance_sum += distance
      
      cl = if distance > 50 then 'icon-remove' else 'icon-ok'
      out_el.append "<li>#{city_name} <span><i class='#{cl}'></i>#{distance} Km</span></li>"
      
    # Trace Feedback    
    feedback = @getMessage( {distance: distance_sum} ).feedback
      
    if distance_sum < 500
      msg_out.html( feedback.best )
      msg_out.removeClass('alert-info').addClass('alert-success')
    else if distance_sum < 1000
      msg_out.html( feedback.ok )
      msg_out.removeClass('alert-info').addClass('alert-block')  
    else
      msg_out.html( feedback.bad )
      msg_out.removeClass('alert-info').addClass('alert-error')
      
  # ---------------------------------------------------  
  # --- Get Message
  # ---------------------------------------------------    
  getMessage: (opt) ->
      feedback:
        best: "<strong>Super!</strong> Du hast bist mit #{opt.distance} Km unter den Besten."
        ok:   "<strong>OK!</strong> Du bist mit nur #{opt.distance} Km Abweichung noch ganz gut dabei." 
        bad:  "<strong>Nicht so gut!</strong> #{opt.distance} Km abweichung sind etwas zu viele, du solltest dein geographisches Wissen etwas auffrischen."
        
# ---------------------------------------------    

# Add Class to global context
window.EmptyMap = EmptyMap