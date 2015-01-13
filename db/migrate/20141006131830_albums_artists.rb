class AlbumsArtists < ActiveRecord::Migration
  def self.up
    # Create the association table
    create_table :albums_artists, :id => false do |t|
      t.integer :album_id, :null => false
      t.integer :artist_id, :null => false
    end

    # Add table index
    add_index :albums_artists, [:album_id, :artist_id], :unique => true

  end

  def self.down
    remove_index :albums_artists, :column => [:album_id, :artist_id]
    drop_table :albums_artists
  end
end
