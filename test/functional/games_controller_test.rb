require 'test_helper'

class GamesControllerTest < ActionController::TestCase

  
  # --- Basic Test if Application Index-Page exists
  test "should get index" do
    get :index
    assert_response :success, "Site can not reached"
    assert_not_nil assigns(:games), "There are no Games on this site" 
  end    
  
  
  # --- Show Game "Biggest 10 Cities"
  test "should get Game 'Biggest 10 Cities'" do
    game_id = 1
    get :biggest_10_cities, {:id => game_id}
    assert_response :success, "Game 'Biggest 10 Cities' not found"
    assert_not_nil assigns(:game), "There is no game with ID: #{game_id}"
  end    
  
  
  # --- Validate Game "Empty-Map"
  test "should Valdate the Result of 'Empty-Map Game'" do
    ps = ['Essen', 'Hamburg']
    get :validate_empty_map, {:cities => ps}
    assert_response :success, "could not Call validation for 'Empty-Map Game'"    
    
    resp = JSON.parse( @response.body )
    assert_equal( resp.size, ps.size, "Number of questions does not match the number of answeres" )
    assert( ps.include?( resp.first['title'] ), "Your answere does not match my question" )
  end
end
