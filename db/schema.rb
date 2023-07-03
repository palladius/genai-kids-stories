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

ActiveRecord::Schema[7.0].define(version: 2023_07_03_050041) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

# Could not dump table "kids" because of following StandardError
#   Unknown type '' for column 'avatar'

  create_table "stories", force: :cascade do |t|
    t.string "title"
    t.text "genai_input"
    t.text "genai_output"
    t.text "genai_summary"
    t.text "internal_notes"
    t.integer "user_id"
    t.integer "kid_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kid_id"], name: "index_stories_on_kid_id"
  end

  create_table "story_paragraphs", force: :cascade do |t|
    t.integer "story_index"
    t.text "original_text"
    t.text "genai_input_for_image"
    t.text "internal_notes"
    t.text "translated_text"
    t.string "language"
    t.integer "story_id", null: false
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "translated_story_id"
    t.index ["story_id"], name: "index_story_paragraphs_on_story_id"
    t.index ["translated_story_id"], name: "index_story_paragraphs_on_translated_story_id"
  end

  create_table "story_templates", force: :cascade do |t|
    t.string "short_code"
    t.string "description"
    t.text "template"
    t.text "internal_notes"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "translated_stories", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.integer "story_id", null: false
    t.string "language"
    t.integer "kid_id"
    t.string "paragraph_strategy"
    t.text "internal_notes"
    t.string "genai_model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "\"client_id\"", name: "index_translated_stories_on_client_id"
    t.index ["story_id"], name: "index_translated_stories_on_story_id"
    t.index ["user_id"], name: "index_translated_stories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "internal_notes"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "stories", "kids"
  add_foreign_key "story_paragraphs", "stories"
  add_foreign_key "story_paragraphs", "translated_stories"
  add_foreign_key "translated_stories", "stories"
  add_foreign_key "translated_stories", "users"
end
