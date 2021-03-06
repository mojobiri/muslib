# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141013133139) do

  create_table "albums", force: true do |t|
    t.string   "name"
    t.integer  "band_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "albums_artists", id: false, force: true do |t|
    t.integer "album_id",  null: false
    t.integer "artist_id", null: false
  end

  add_index "albums_artists", ["album_id", "artist_id"], name: "index_albums_artists_on_album_id_and_artist_id", unique: true

  create_table "artists", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.datetime "birth_date"
    t.datetime "death_date"
    t.boolean  "alive"
    t.string   "country"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "artists_bands", id: false, force: true do |t|
    t.integer "band_id",   null: false
    t.integer "artist_id", null: false
  end

  add_index "artists_bands", ["band_id", "artist_id"], name: "index_artists_bands_on_band_id_and_artist_id", unique: true

  create_table "bands", force: true do |t|
    t.string   "name"
    t.string   "country"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bands_genres", id: false, force: true do |t|
    t.integer "band_id",  null: false
    t.integer "genre_id", null: false
  end

  add_index "bands_genres", ["band_id", "genre_id"], name: "index_bands_genres_on_band_id_and_genre_id", unique: true

  create_table "genres", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "genres", ["name"], name: "index_genres_on_name", unique: true

  create_table "leaders", force: true do |t|
    t.integer  "artist_id"
    t.integer  "band_id"
    t.boolean  "leader",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: true do |t|
    t.integer  "value"
    t.integer  "band_id"
    t.integer  "album_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
