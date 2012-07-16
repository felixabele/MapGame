class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :map_id
      t.string :name
      t.text :description      

      t.timestamps
    end
  end
end
