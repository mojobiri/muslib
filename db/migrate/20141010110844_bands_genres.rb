class BandsGenres < ActiveRecord::Migration
  def self.up
    # Create the association table
    create_table :bands_genres, :id => false do |t|
      t.integer :band_id, :null => false
      t.integer :genre_id, :null => false
    end

    # Add table index
    add_index :bands_genres, [:band_id, :genre_id], :unique => true

  end

  def self.down
    remove_index :bands_genres, :column => [:band_id, :genre_id]
    drop_table :bands_genres
  end
end
