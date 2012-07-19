require 'test_helper'

class MapTest < ActiveSupport::TestCase

  # --- Get Map-Data as JSON for GeoCloud jQuery Plugin
  test "should return map data as json" do 
    country = 'germany'
    map = Map.find_by_country(country)
    assert_not_nil( map, "is there a Map of #{country}" )
    assert_kind_of( Hash, JSON.parse(map.to_json), "does 'get_geocloud_json' return valid JSON" )
  end    
  
end
