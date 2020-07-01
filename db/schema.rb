# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_01_150644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "classrooms", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_classrooms_on_user_id"
  end

  create_table "group_work_sheets", force: :cascade do |t|
    t.bigint "worksheet_id", null: false
    t.bigint "work_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["work_group_id"], name: "index_group_work_sheets_on_work_group_id"
    t.index ["worksheet_id"], name: "index_group_work_sheets_on_worksheet_id"
  end

  create_table "student_classrooms", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "classroom_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["classroom_id"], name: "index_student_classrooms_on_classroom_id"
    t.index ["user_id"], name: "index_student_classrooms_on_user_id"
  end

  create_table "student_work_groups", force: :cascade do |t|
    t.boolean "turn"
    t.boolean "joined"
    t.bigint "user_id", null: false
    t.bigint "work_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_student_work_groups_on_user_id"
    t.index ["work_group_id"], name: "index_student_work_groups_on_work_group_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "work_groups", force: :cascade do |t|
    t.string "name"
    t.string "video_call_code"
    t.integer "session_time"
    t.integer "turn_time"
    t.integer "score"
    t.integer "answered"
    t.datetime "start_at"
    t.bigint "classroom_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "aasm_state"
    t.index ["classroom_id"], name: "index_work_groups_on_classroom_id"
  end

  create_table "worksheets", force: :cascade do |t|
    t.json "display_content"
    t.json "correct_content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "classrooms", "users"
  add_foreign_key "group_work_sheets", "work_groups"
  add_foreign_key "group_work_sheets", "worksheets"
  add_foreign_key "student_classrooms", "classrooms"
  add_foreign_key "student_classrooms", "users"
  add_foreign_key "student_work_groups", "users"
  add_foreign_key "student_work_groups", "work_groups"
  add_foreign_key "work_groups", "classrooms"
end
