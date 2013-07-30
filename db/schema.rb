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

ActiveRecord::Schema.define(version: 20130727214433) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "earthquakes", force: true do |t|
    t.string   "source"
    t.string   "eqid"
    t.string   "version"
    t.datetime "occurred_at"
    t.float    "magnitude"
    t.float    "depth"
    t.integer  "number_of_stations_reported"
    t.string   "region"
    t.spatial  "location",                    limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "earthquakes", ["location"], :name => "index_earthquakes_on_location", :spatial => true
  add_index "earthquakes", ["magnitude"], :name => "index_earthquakes_on_magnitude"
  add_index "earthquakes", ["occurred_at"], :name => "index_earthquakes_on_occurred_at"
  add_index "earthquakes", ["region"], :name => "index_earthquakes_on_region"
  add_index "earthquakes", ["source", "eqid"], :name => "index_earthquakes_on_source_and_eqid", :unique => true

end
