class CreateArtists < ActiveRecord::Migration
  def change
  	create_table :artists do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.datetime :birth_date
      t.datetime :death_date
      t.boolean :alive
      t.string :country
      t.text :description
      t.timestamps
    end
  end
end
