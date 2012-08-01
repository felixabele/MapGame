class AddRegionToCity < ActiveRecord::Migration
  def change
    add_column :cities, :region, :int
  end
end
