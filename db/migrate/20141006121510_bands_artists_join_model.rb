class BandsArtistsJoinModel < ActiveRecord::Migration
  def self.up
    # Create the association table
    create_table :artists_bands, :id => false do |t|
      t.integer :band_id, :null => false
      t.integer :artist_id, :null => false
    end

    # Add table index
    add_index :artists_bands, [:band_id, :artist_id], :unique => true

  end

  def self.down
    remove_index :artists_bands, :column => [:band_id, :artist_id]
    drop_table :artists_bands
  end
end
