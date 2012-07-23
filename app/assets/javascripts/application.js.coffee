#= require jquery
#= require jquery_ujs
#= require_tree .

$(document).ready ->
  load_javascript($("body").data('controller'),$("body").data('action'))

load_javascript = (controller,action) ->
  $.event.trigger "#{controller}.load"
  $.event.trigger "#{action}_#{controller}.load"
