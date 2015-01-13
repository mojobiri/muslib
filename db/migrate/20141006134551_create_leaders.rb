class CreateLeaders < ActiveRecord::Migration
  def change
    create_table :leaders do |t|
        t.belongs_to :artist
        t.belongs_to :band
        t.boolean :leader, default: false
        t.timestamps
    end
  end
end
