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

ActiveRecord::Schema[7.0].define(version: 2023_03_20_104506) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "glossaries", force: :cascade do |t|
    t.bigint "source_language_code_id"
    t.bigint "target_language_code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_language_code_id", "target_language_code_id"], name: "idx_unique_glossaries", unique: true
    t.index ["source_language_code_id"], name: "index_glossaries_on_source_language_code_id"
    t.index ["target_language_code_id"], name: "index_glossaries_on_target_language_code_id"
  end

  create_table "language_codes", force: :cascade do |t|
    t.string "code", limit: 2, null: false
    t.string "country", null: false
    t.index ["code"], name: "index_language_codes_on_code", unique: true
  end

  create_table "terms", force: :cascade do |t|
    t.string "source_text", null: false
    t.string "target_text", null: false
    t.bigint "glossary_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["glossary_id"], name: "index_terms_on_glossary_id"
  end

  create_table "translations", force: :cascade do |t|
    t.bigint "source_language_code_id"
    t.bigint "target_language_code_id"
    t.bigint "glossary_id"
    t.text "source_text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["glossary_id"], name: "index_translations_on_glossary_id"
    t.index ["source_language_code_id"], name: "index_translations_on_source_language_code_id"
    t.index ["target_language_code_id"], name: "index_translations_on_target_language_code_id"
  end

  add_foreign_key "glossaries", "language_codes", column: "source_language_code_id"
  add_foreign_key "glossaries", "language_codes", column: "target_language_code_id"
  add_foreign_key "terms", "glossaries"
  add_foreign_key "translations", "language_codes", column: "source_language_code_id"
  add_foreign_key "translations", "language_codes", column: "target_language_code_id"
end
