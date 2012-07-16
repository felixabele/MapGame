class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :country
      t.string :size
      t.string :geo_settings
      t.string :ref_point
      t.integer :width
      t.integer :height
      t.string :map_file
    end
  end
end
