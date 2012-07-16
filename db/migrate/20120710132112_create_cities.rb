class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :population
      t.float :lon
      t.float :lat
      t.string :map_id
    end
  end
end
