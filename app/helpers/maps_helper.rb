module MapsHelper
  
  # =================================
  #   jQuery.GeoCloud - Helper
  # =================================
  # --- Init Map
  def init_map( map )
    js = ""
    js << "$('#map_#{map.country}').geocloud({"
    js << " \"width\": #{map.width}, height: #{map.height},"
    js << " \"map_src\": \"/assets/maps/#{map.map_file}\","
    js << " \"geo_settings\": {#{map.geo_settings}},"
    js << " \"ref_point\": {#{map.ref_point}}"
    js << "});"
    js.html_safe
  end
  
  
  # --- Insert Cities
  # @params: cities: array of cities
  def cities_for_geocloud2( cities, size=10 )
    ds = Array.new
    cities.each do |city|
      ds << "{\"title\": \"#{city.name}\", \"size\": #{size}, \"coord\": [#{city.lon},#{city.lat}], \"id\": #{city.id}}"
    end
    "[#{ds.join(',')}]".html_safe
  end
end