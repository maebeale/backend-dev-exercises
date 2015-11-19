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

ActiveRecord::Schema.define(version: 20151118013836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "census_data", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "workclass_id"
    t.integer  "education_level_id"
    t.integer  "marital_status_id"
    t.integer  "occupation_id"
    t.integer  "relationship_id"
    t.integer  "race_id"
    t.integer  "sex_id"
    t.integer  "country_id"
    t.float    "age"
    t.float    "education_num"
    t.float    "capital_gain"
    t.float    "capital_loss"
    t.float    "hours_week"
    t.boolean  "over_50k",           default: false, null: false
    t.string   "country"
    t.string   "education_level"
    t.string   "marital_status"
    t.string   "occupation"
    t.string   "race"
    t.string   "relationship"
    t.string   "sex"
    t.string   "workclass"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
