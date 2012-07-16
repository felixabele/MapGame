class Map < ActiveRecord::Base
  attr_accessible :country, :geo_settings, :height, :id, :map_file, :ref_point, :size, :width
      
  has_many :games  
  has_many :cities
end
