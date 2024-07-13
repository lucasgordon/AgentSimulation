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

ActiveRecord::Schema[7.1].define(version: 2024_07_13_185426) do
  create_table "agents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "model"
    t.float "temperature"
    t.text "system_prompt"
    t.float "top_p"
  end

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "agent_id", null: false
    t.string "model_ids"
    t.index ["agent_id"], name: "index_conversations_on_agent_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "message_text"
    t.integer "agent_id", null: false
    t.integer "conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_messages_on_agent_id"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
  end

  add_foreign_key "conversations", "agents"
  add_foreign_key "messages", "agents"
  add_foreign_key "messages", "conversations"
end