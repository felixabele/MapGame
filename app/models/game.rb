class Game < ActiveRecord::Base
  attr_accessible :description, :id, :name, :map_id
  
  belongs_to :map
  has_many :cities, :through => :map
end
