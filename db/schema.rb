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

ActiveRecord::Schema[7.2].define(version: 2024_09_20_000005) do
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

  create_table "building_blocks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "building_blocks_hiraganas", id: false, force: :cascade do |t|
    t.bigint "hiragana_id", null: false
    t.bigint "building_block_id", null: false
    t.index ["building_block_id", "hiragana_id"], name: "idx_on_building_block_id_hiragana_id_e134e9fb94"
    t.index ["hiragana_id", "building_block_id"], name: "idx_on_hiragana_id_building_block_id_27eb2f5085"
  end

  create_table "hiraganas", force: :cascade do |t|
    t.string "name"
    t.text "memo"
    t.text "story"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "translated_name"
  end

  create_table "word_game_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_word_index", default: 0
  end

  create_table "word_game_sessions_right_answers", id: false, force: :cascade do |t|
    t.bigint "word_game_session_id", null: false
    t.bigint "word_id", null: false
    t.index ["word_game_session_id", "word_id"], name: "index_wgs_right_answers"
    t.index ["word_id", "word_game_session_id"], name: "index_right_answers_wgs"
  end

  create_table "word_game_sessions_words", id: false, force: :cascade do |t|
    t.bigint "word_game_session_id", null: false
    t.bigint "word_id", null: false
    t.index ["word_game_session_id", "word_id"], name: "idx_on_word_game_session_id_word_id_c9bc447f30"
    t.index ["word_id", "word_game_session_id"], name: "idx_on_word_id_word_game_session_id_5e0aafa943"
  end

  create_table "word_game_sessions_wrong_answers", id: false, force: :cascade do |t|
    t.bigint "word_game_session_id", null: false
    t.bigint "word_id", null: false
    t.index ["word_game_session_id", "word_id"], name: "index_wgs_wrong_answers"
    t.index ["word_id", "word_game_session_id"], name: "index_wrong_answers_wgs"
  end

  create_table "words", force: :cascade do |t|
    t.string "hiragana"
    t.string "romanji"
    t.string "kanji"
    t.string "english_meaning"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
