class Map < ActiveRecord::Base
  attr_accessible :country, :geo_settings, :height, :id, :map_file, :ref_point, :size, :width
      
  has_many :games  
  has_many :cities
  
  # --- Get Map-Data for  jQuery Geocloud-Plugin
  def get_geocloud_json
    { :country      => self.country, 
      :geo_settings => eval(self.geo_settings),
      :ref_point    => eval(self.ref_point),
      :width        => self.width,
      :height       => self.height,
      :map_src      => "/assets/maps/#{self.map_file}"}.to_json
  end
end
