class CreateRating < ActiveRecord::Migration
  def change
	create_table :ratings do |t|
		t.integer :value
		t.belongs_to :band
		t.belongs_to :album
		t.timestamps
	end
  end
end
