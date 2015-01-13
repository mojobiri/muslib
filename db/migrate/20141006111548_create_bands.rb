class CreateBands < ActiveRecord::Migration
  def change
  	create_table :bands do |t|
      t.string :name
      t.string :country
      t.text :description
      t.timestamps
    end
  end
end
