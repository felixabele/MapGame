require 'test_helper'

# call me with: ruby -Itest test/unit/city_test.rb

class CityTest < ActiveSupport::TestCase
  
  # --- Import Cities by CSV
  test "should import all cities of Germany from a file" do    
    assert City.do_import('Utopia', 1) == false, "There is no such File 'Utopia.txt'"    
    assert_equal City.do_import('test_deutschland', 1), 5, "Row Count does Match Record count"    
    assert_not_nil City.find_by_name('Hamburg'), "Is there a city named Hamburg"
    assert_equal City.find_by_name('Hamburg').population, 1786448, "Does Hamburg habe a Population of 1.786.448 Mio"
  end     
  
  # --- Geocode a single City
  test "should Geocode a City with Geocoder Gem" do 
    berlin = City.find_by_name('Berlin')
    assert berlin.update_geocodes, "do you find Geocodes for the city of Berlin"
    assert_equal berlin.lon, 13.4060912, "do you find any Coordinates for Berlin"
  end  
end