class CreateAlbums < ActiveRecord::Migration
  def change
	create_table :albums do |t|
		t.string :name
		t.belongs_to :band
		t.text :description
		t.timestamps
	end
  end
end