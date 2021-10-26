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

ActiveRecord::Schema.define(version: 2021_10_21_154742) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "official_given_name"
    t.string "official_family_name"
    t.string "preferred_given_name"
    t.string "preferred_family_name"
    t.string "local_given_name"
    t.string "local_family_name"
    t.string "other_given_names"
    t.string "display_name"
    t.string "formal_name"
    t.string "sort_name"
    t.jsonb "additional_name_details"
    t.date "date_of_birth"
    t.string "gender"
    t.string "school_email"
    t.string "personal_email"
    t.string "school_phone"
    t.string "personal_phone"
    t.jsonb "other_contact_details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.check_constraint "(official_given_name IS NOT NULL) OR (preferred_given_name IS NOT NULL)", name: "given_name_check"
  end

end
