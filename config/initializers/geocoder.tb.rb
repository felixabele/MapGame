# config/initializers/geocoder.rb
Geocoder.configure do |config|

  # geocoding service (see below for supported options):
  #config.lookup = :google
  
  # to use an API key:
  #config.api_key = "AIzaSyDCf-Q2r3tr6gMI7s7EEPX0jq4zaPwSgVQ" # Google (https://code.google.com/apis/console/)
  #config.api_key = "Ag0S7pVlwtFlnKSS_dq_XrOo8AV4o9ZkmurjRPyJgr3meBRuGBrjMbZgmncVwd_e" # Bing
  #config.api_key = "eV8zL1jV34FYhH2dEG_M7ixzVt1QgIhu2lYuZtbMsyN7frzRWu_Er56a9dyqcvIN4AkzNeYptU8WtNQGf0i5o8D5jmW16CA-"; # yahoo

  # set default units to kilometers:
  config.units = :km

  # caching (see below for details):
  # config.cache = Redis.new
  # config.cache_prefix = "..."

end