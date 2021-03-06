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

ActiveRecord::Schema.define(version: 2018_07_05_224947) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "parking_assignments", force: :cascade do |t|
    t.bigint "space_id"
    t.bigint "vehicle_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["space_id", "ended_at"], name: "index_parking_assignments_on_space_id_and_ended_at", unique: true
    t.index ["space_id"], name: "index_parking_assignments_on_space_id"
    t.index ["vehicle_id"], name: "index_parking_assignments_on_vehicle_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.integer "floor"
    t.string "section"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "license_state", null: false
    t.string "license_number", null: false
    t.string "description"
    t.string "contact_name"
    t.string "contact_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "parking_assignments", "spaces"
  add_foreign_key "parking_assignments", "vehicles"
end
