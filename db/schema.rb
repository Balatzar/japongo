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

ActiveRecord::Schema[7.2].define(version: 2024_09_21_111245) do
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

  create_table "cards", force: :cascade do |t|
    t.text "front"
    t.text "back"
    t.datetime "next_review"
    t.integer "interval", default: 0
    t.float "ease_factor", default: 2.5
    t.integer "repetitions", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["front"], name: "index_cards_on_front", unique: true
  end

  create_table "connections", force: :cascade do |t|
    t.integer "source_node_id"
    t.integer "target_node_id"
    t.bigint "skill_tree_id", null: false
    t.boolean "required_to_unlock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_tree_id"], name: "index_connections_on_skill_tree_id"
  end

  create_table "crossword_game_sessions", force: :cascade do |t|
    t.json "grid"
    t.json "clues"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "easy_mode", default: false
  end

  create_table "crossword_game_sessions_words", id: false, force: :cascade do |t|
    t.bigint "crossword_game_session_id", null: false
    t.bigint "word_id", null: false
    t.index ["crossword_game_session_id", "word_id"], name: "idx_on_crossword_game_session_id_word_id_a76196a1d8"
    t.index ["word_id", "crossword_game_session_id"], name: "idx_on_word_id_crossword_game_session_id_3ae811a66d"
  end

  create_table "hiraganas", force: :cascade do |t|
    t.string "name"
    t.text "memo"
    t.text "story"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "translated_name"
  end

  create_table "quests", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "unlocked"
    t.boolean "completed"
    t.bigint "skill_node_id", null: false
    t.jsonb "stat_reward"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_node_id"], name: "index_quests_on_skill_node_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "card_id", null: false
    t.datetime "reviewed_at"
    t.integer "grade"
    t.integer "review_duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_reviews_on_card_id"
  end

  create_table "skill_nodes", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "skill_tree_id", null: false
    t.integer "position_x"
    t.integer "position_y"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_tree_id"], name: "index_skill_nodes_on_skill_tree_id"
  end

  create_table "skill_trees", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stat_modifiers", force: :cascade do |t|
    t.bigint "skill_node_id", null: false
    t.bigint "stat_id", null: false
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_node_id"], name: "index_stat_modifiers_on_skill_node_id"
    t.index ["stat_id"], name: "index_stat_modifiers_on_stat_id"
  end

  create_table "stats", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "skill_tree_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_tree_id"], name: "index_stats_on_skill_tree_id"
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
  add_foreign_key "connections", "skill_trees"
  add_foreign_key "quests", "skill_nodes"
  add_foreign_key "reviews", "cards"
  add_foreign_key "skill_nodes", "skill_trees"
  add_foreign_key "stat_modifiers", "skill_nodes"
  add_foreign_key "stat_modifiers", "stats"
  add_foreign_key "stats", "skill_trees"
end
