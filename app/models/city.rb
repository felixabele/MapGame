class City < ActiveRecord::Base
  
  require 'open-uri'

  attr_accessible :lat, :lon, :name, :population, :map_id
  belongs_to :map
  
  
  
  # --- Get The biggest Cities
  def self.biggest(limit=10)
    self.order( "population DESC" ).limit( limit )
  end

  # --- Get Cities randomly
  def self.random(limit=10)
    self.order( "RAND()" ).limit( limit )
  end
  
  # --- Get Cities By name Array
  def self.get_by_name_array( name_array, limit=10 )
    n_str = name_array.collect{|c| "'#{c}'"}.join(',')
    self.where( "name IN (#{n_str})" ).order( "population DESC" ).limit( limit )
  end  
  
  # ===================================
  #   Update Geocode
  # ===================================
  def update_geocodes (country = '')
    place = Geocoder.search("#{self.name}, #{country}").first
    sleep(0.3)
    unless place.nil?
      self.lat = place.geometry['location']['lat']
      self.lon = place.geometry['location']['lng']
      return self.save
    end
    false
  end
  
  # get Geocodes From Google
=begin  
  def self.do_geocode (address)
    address = URI::encode(address);
    uri = "http://maps.googleapis.com/maps/api/geocode/json?address=#{address}&sensor=false"
    contents = URI.parse(uri).read    
    JSON.parse(contents)
  end 
=end
  
  # ===================================
  #   IMPORT BY FILE
  # ===================================
  def self.do_import( country, map_id )
    
    row_count = 0
    src = "#{Rails.root}/lib/#{country}.txt"
    begin
      city_file = File.open(src, "r")
    rescue => e
      return false
    end

    # Delete All, to start with
    #self.destroy_all( :map_id => map_id )

    city_file.each do |line| 
      ca = line.split(";")
      begin
        city = self.new({
            :name => ca[0],
            :population => ca[1].gsub(/\D/, '').to_i,
            :map_id => map_id})
      rescue => e
        p e.message, ca
      end  
    
      # Save only if not already in database
      if !(city.nil?) || self.where("name = :city_name AND map_id = :map_id", {:city_name => city.name, :map_id => city.map_id}).nil?
        city.save!      
        # Update Geocodes
        city.update_geocodes( country )
      end      
      row_count += 1
    end
    city_file.close
    row_count
  end  
end
