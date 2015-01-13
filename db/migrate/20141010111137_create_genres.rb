class CreateGenres < ActiveRecord::Migration
  def change
  	create_table :genres do |t|
      t.string :name, unique: true
      t.timestamps
    end
    add_index :genres, :name, unique: true
  end
end
