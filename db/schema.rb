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

ActiveRecord::Schema.define(version: 2020_10_15_135428) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "classrooms", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "subject"
    t.string "group"
    t.integer "grade"
    t.datetime "start_time"
    t.datetime "end_time"
    t.index ["user_id"], name: "index_classrooms_on_user_id"
  end

  create_table "images", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.integer "role", default: 0
    t.string "authentication_token", limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
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
    t.boolean "worksheet_email_sent", default: false
    t.index ["classroom_id"], name: "index_work_groups_on_classroom_id"
  end

  create_table "worksheet_reviews", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "worksheet_id", null: false
    t.index ["user_id"], name: "index_worksheet_reviews_on_user_id"
    t.index ["worksheet_id"], name: "index_worksheet_reviews_on_worksheet_id"
  end

  create_table "worksheet_templates", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image_url"
    t.index ["user_id"], name: "index_worksheet_templates_on_user_id"
  end

  create_table "worksheets", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.string "canvas"
    t.bigint "worksheet_template_id"
    t.bigint "work_group_id"
    t.string "image_url"
    t.string "template_image_url"
    t.index ["work_group_id"], name: "index_worksheets_on_work_group_id"
    t.index ["worksheet_template_id"], name: "index_worksheets_on_worksheet_template_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "classrooms", "users"
  add_foreign_key "student_classrooms", "classrooms"
  add_foreign_key "student_classrooms", "users"
  add_foreign_key "student_work_groups", "users"
  add_foreign_key "student_work_groups", "work_groups"
  add_foreign_key "work_groups", "classrooms"
  add_foreign_key "worksheet_reviews", "users"
  add_foreign_key "worksheet_reviews", "worksheets"
  add_foreign_key "worksheet_templates", "users"
  add_foreign_key "worksheets", "work_groups"
  add_foreign_key "worksheets", "worksheet_templates"
end
