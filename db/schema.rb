# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_02_205511) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "air_quality_metrics", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.decimal "co", precision: 17, scale: 14
    t.decimal "no", precision: 17, scale: 14
    t.decimal "no2", precision: 17, scale: 14
    t.decimal "o3", precision: 17, scale: 14
    t.decimal "so2", precision: 17, scale: 14
    t.decimal "pm2_5", precision: 17, scale: 14
    t.decimal "pm10", precision: 17, scale: 14
    t.decimal "nh3", precision: 17, scale: 14
    t.datetime "recorded_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_air_quality_metrics_on_location_id"
    t.index ["recorded_at"], name: "index_air_quality_metrics_on_recorded_at"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "latitude", precision: 10, scale: 6, null: false
    t.decimal "longitude", precision: 10, scale: 6, null: false
    t.bigint "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_locations_on_name"
    t.index ["state_id"], name: "index_locations_on_state_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_states_on_name"
  end

  add_foreign_key "air_quality_metrics", "locations"
  add_foreign_key "locations", "states"
end
