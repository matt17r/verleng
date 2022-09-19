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

ActiveRecord::Schema[7.0].define(version: 2022_09_18_125248) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "sis_record_type", ["student", "staff", "contact"]

  create_table "directory_records", force: :cascade do |t|
    t.uuid "person_id", null: false
    t.string "directory_id", null: false
    t.string "email", null: false
    t.string "email_aliases", default: [], null: false, array: true
    t.string "org_unit", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["directory_id"], name: "index_directory_records_on_directory_id", unique: true
    t.index ["email"], name: "index_directory_records_on_email"
    t.index ["person_id"], name: "index_directory_records_on_person_id"
  end

  create_table "family_relationships", force: :cascade do |t|
    t.uuid "contact_id", null: false
    t.uuid "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_family_relationships_on_contact_id"
    t.index ["student_id", "contact_id"], name: "index_family_relationships_on_student_id_and_contact_id", unique: true
    t.index ["student_id"], name: "index_family_relationships_on_student_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.uuid "person_id", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "person_id", "type"], name: "index_group_memberships_on_group_id_and_person_id_and_type", unique: true
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["person_id"], name: "index_group_memberships_on_person_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.string "dir_id"
    t.string "dir_name"
    t.string "dir_email"
    t.string "dir_description"
    t.string "dir_aliases", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dir_email"], name: "index_groups_on_dir_email"
    t.index ["dir_id"], name: "index_groups_on_dir_id", unique: true
    t.index ["dir_name"], name: "index_groups_on_dir_name"
    t.index ["name"], name: "index_groups_on_name"
  end

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.check_constraint "official_given_name IS NOT NULL OR preferred_given_name IS NOT NULL", name: "given_name_check"
  end

  create_table "sis_records", force: :cascade do |t|
    t.uuid "person_id", null: false
    t.string "sis_id"
    t.string "code"
    t.string "family_id"
    t.string "family_code"
    t.string "student_grade"
    t.enum "record_type", null: false, enum_type: "sis_record_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "campus"
    t.index ["code"], name: "index_sis_records_on_code"
    t.index ["person_id"], name: "index_sis_records_on_person_id"
    t.check_constraint "sis_id IS NOT NULL OR code IS NOT NULL", name: "sis_identifier_check"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.string "email_confirmation_token", default: "", null: false
    t.datetime "email_confirmed_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  add_foreign_key "directory_records", "people"
  add_foreign_key "family_relationships", "people", column: "contact_id"
  add_foreign_key "family_relationships", "people", column: "student_id"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "people"
  add_foreign_key "sis_records", "people"
end
