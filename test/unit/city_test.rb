require 'test_helper'

# call me with: ruby -Itest test/unit/city_test.rb
# or: rake test TEST=test/unit/city_test.rb

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
  
  # --- Get the 2 Biggest Cities
  test "should return the 2 Biggest Cities" do     
    cities = City.biggest(2)
    assert_equal( cities.size, 2, "does the City return two datasets")
    assert_equal( cities[0].name, 'Berlin', "is the Biggest City 'Berlin'")
    assert_equal( cities[1].name, 'Hamburg', "is the second Biggest City 'Hamburg'")
  end  
  
  # --- Get the some cities by Random
  test "should return 2 random Cities" do     
    cities1 = City.random(2)
    cities2 = City.random(2)
    assert_not_equal( cities1[0].name, cities2[1].name, "is the first City not equal to the second")
  end    
end