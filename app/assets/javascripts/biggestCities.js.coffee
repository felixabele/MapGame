# ============================================
# --- Game Classes
# ============================================ 
# 10 Biggest Cities of a country
class BiggestCities
  constructor: (@output_el, @submit_el, @clear_el) ->
    
    # SETTINGS
    @stack = 1:'',2:'',3:'',4:'',5:'',6:'',7:'',8:'',9:'',10:''
    @stack_size = 10
    @filled_slots = 0
    @game_id = ''
    @validation_action = '/validate_biggest_cities'
    @is_active = true
    @message_el = '.alert'
  
  # --- Setter
  setGameId: (game_id) ->
    @game_id = game_id
  
  # --- get City Names (keys of the stack)
  getCityNames: ->
    cn = []
    for index, slot of @stack
      cn.push slot
    cn
  
  # ---------------------------------------------------
  # -- find the next empty slot and Add the City to it
  # ---------------------------------------------------
  addCity: (ref) ->   
    for index, slot of @stack
      if slot is ''
        @stack[index] = ref
        @filled_slots++
        @refreshOutput()
        break    
    index
  
  # ---------------------------------------------------
  # -- find the slot and empty it
  # ---------------------------------------------------
  removeCity: (index) ->
    @stack[index] = ''
    @filled_slots--
    @refreshOutput()
    
  # ---------------------------------------------------  
  # --- Show Changes in Output-Box
  # ---------------------------------------------------
  refreshOutput: ->
    output_element = $(@output_el)
    submit_element = $(@submit_el)
    output_element.html( '' )
    
    for index, slot of @stack
      output_element.append "<li>#{slot}</li>"      
    
    # Activate Submit-Button as soon as all Cities have been selected
    if @filled_slots is @stack_size
      submit_element.removeClass 'disabled'
    else if not submit_element.hasClass 'disabled'
      submit_element.addClass 'disabled'
     
  # ---------------------------------------------------  
  # --- Submit Game (only if game is still active)
  # ---------------------------------------------------
  submit: -> 
    if @is_active
      $.ajax 
        url: "#{@validation_action}/#{@game_id}"
        type: 'POST'
        dataType: 'json'
        data: 
          cities: @getCityNames()
        error: (jqXHR, textStatus, errorThrown) ->
          console.log "Validtion failed: #{textStatus}"
        success: (data, textStatus, jqXHR) =>
          @validate(data)      

  # Validate with Data from Database
  validate: (results) ->
    c = 0
    errors = 0
    $(@output_el).find( 'li' ).each ->
      result = results[c]
      el = $(@)
      my_answere = el.html()      
      if my_answere == result.name
        el.addClass 'correct'
        el.html "#{my_answere} <span><i class='icon-ok'></i>#{result.population} Einw.</span>"
      else 
        el.addClass 'incorrect'
        el.html "<s>#{my_answere}</s> <span><i class='icon-remove'></i>#{result.name} #{result.population} Einw.</span>"
        errors++
      c++
      
    # Trace Feedback
    msg_out = $( @message_el )
    feedback = @getMessage( {errors: errors} ).feedback
      
    if errors == 0
      msg_out.html( feedback.best )
      msg_out.removeClass('alert-info').addClass('alert-success')
    else if errors < 6
      msg_out.html( feedback.ok )
      msg_out.removeClass('alert-info').addClass('alert-block')  
    else
      msg_out.html( feedback.bad )
      msg_out.removeClass('alert-info').addClass('alert-error')          
    
    msg_out.append("<br /> <a href='/'>Zurück zur Übersicht</a>")
    
    # by this time the game has finished  
    $(@clear_el).hide()
    $(@submit_el).hide()
    @is_active = false
    
  # ---------------------------------------------------  
  # --- Reset Game
  # ---------------------------------------------------  
  reset: ->
    if @is_active
      for index, slot of @stack
        @stack[index] = ''
      @filled_slots = 0
      $(@output_el).html ''
  
  # ---------------------------------------------------  
  # --- Get Message
  # ---------------------------------------------------    
  getMessage: (opt) ->
      feedback:
        best: "<strong>Super!</strong> Du hast alle Städte korrekt eingeordnet."
        ok:   "<strong>OK!</strong> Du bist mit nur #{opt.errors} Fehlern noch ganz gut dabei." 
        bad:  "<strong>Nicht so gut!</strong> #{opt.errors} Fehler sind etwas zu viele, du solltest dein geographisches Wissen etwas auffrischen."        
  
# ---------------------------------------------    

# Add Class to global context
window.BiggestCities = BiggestCities
