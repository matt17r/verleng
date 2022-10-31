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

ActiveRecord::Schema[7.0].define(version: 2022_10_31_090541) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "group_role", ["owner", "manager", "member"]

  create_table "family_relationships", force: :cascade do |t|
    t.uuid "contact_id", null: false
    t.uuid "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_family_relationships_on_contact_id"
    t.index ["student_id", "contact_id"], name: "index_family_relationships_on_student_id_and_contact_id", unique: true
    t.index ["student_id"], name: "index_family_relationships_on_student_id"
  end

  create_table "gwd_email_contacts", id: :string, force: :cascade do |t|
    t.uuid "person_id"
    t.string "email", null: false
    t.date "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_gwd_email_contacts_on_deleted_at"
    t.index ["email"], name: "index_gwd_email_contacts_on_email"
    t.index ["person_id"], name: "index_gwd_email_contacts_on_person_id"
  end

  create_table "gwd_group_memberships", id: :string, force: :cascade do |t|
    t.string "group_id", null: false
    t.string "member_type", null: false
    t.string "member_id", null: false
    t.string "email", null: false
    t.enum "role", null: false, enum_type: "group_role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_gwd_group_memberships_on_group_id"
    t.index ["member_type", "member_id"], name: "index_gwd_group_memberships_on_member"
  end

  create_table "gwd_groups", id: :string, force: :cascade do |t|
    t.string "etag", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "description"
    t.string "aliases"
    t.date "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_gwd_groups_on_deleted_at"
    t.index ["email"], name: "index_gwd_groups_on_email"
    t.index ["name"], name: "index_gwd_groups_on_name"
  end

  create_table "gwd_users", id: :string, force: :cascade do |t|
    t.uuid "person_id"
    t.string "etag", null: false
    t.string "given_name"
    t.string "family_name"
    t.string "full_name"
    t.string "email", null: false
    t.string "email_aliases", default: [], null: false, array: true
    t.string "org_unit", null: false
    t.boolean "suspended", null: false
    t.date "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "image_etag"
    t.index ["deleted_at"], name: "index_gwd_users_on_deleted_at"
    t.index ["email"], name: "index_gwd_users_on_email"
    t.index ["org_unit"], name: "index_gwd_users_on_org_unit"
    t.index ["person_id"], name: "index_gwd_users_on_person_id"
    t.index ["suspended"], name: "index_gwd_users_on_suspended"
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

  create_table "sycamore_contacts", force: :cascade do |t|
    t.uuid "person_id"
    t.integer "family_id"
    t.string "family_role"
    t.string "given_name"
    t.string "family_name"
    t.string "email"
    t.string "mobile_phone"
    t.string "work_phone"
    t.string "home_phone"
    t.boolean "primary_parent"
    t.boolean "authorised_pickup"
    t.boolean "emergency_contact"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_sycamore_contacts_on_email"
    t.index ["family_name"], name: "index_sycamore_contacts_on_family_name"
    t.index ["given_name"], name: "index_sycamore_contacts_on_given_name"
    t.index ["mobile_phone"], name: "index_sycamore_contacts_on_mobile_phone"
    t.index ["person_id"], name: "index_sycamore_contacts_on_person_id"
  end

  create_table "sycamore_students", force: :cascade do |t|
    t.uuid "person_id"
    t.string "code", null: false
    t.string "given_name"
    t.string "family_name"
    t.string "preferred_name"
    t.date "birthday"
    t.string "gender"
    t.string "location"
    t.string "grade"
    t.string "email"
    t.string "phone"
    t.integer "family_id"
    t.integer "family2_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_sycamore_students_on_code"
    t.index ["email"], name: "index_sycamore_students_on_email"
    t.index ["family_id"], name: "index_sycamore_students_on_family_id"
    t.index ["family_name"], name: "index_sycamore_students_on_family_name"
    t.index ["given_name"], name: "index_sycamore_students_on_given_name"
    t.index ["grade"], name: "index_sycamore_students_on_grade"
    t.index ["location"], name: "index_sycamore_students_on_location"
    t.index ["person_id"], name: "index_sycamore_students_on_person_id"
    t.index ["phone"], name: "index_sycamore_students_on_phone"
    t.index ["preferred_name"], name: "index_sycamore_students_on_preferred_name"
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

  add_foreign_key "family_relationships", "people", column: "contact_id"
  add_foreign_key "family_relationships", "people", column: "student_id"
  add_foreign_key "gwd_email_contacts", "people"
  add_foreign_key "gwd_users", "people"
  add_foreign_key "sycamore_contacts", "people"
  add_foreign_key "sycamore_students", "people"
end
