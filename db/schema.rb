# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150415102543) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name", "type", "user_id"], name: "index_categories_on_name_and_type_and_user_id", unique: true
  add_index "categories", ["user_id"], name: "index_categories_on_user_id"

  create_table "lures", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memories", force: true do |t|
    t.integer  "user_id"
    t.text     "description"
    t.date     "occured_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "weather"
    t.text     "conclusion"
    t.string   "pond_state"
  end

  add_index "memories", ["user_id", "occured_at"], name: "index_memories_on_user_id_and_occured_at"
  add_index "memories", ["user_id"], name: "index_memories_on_user_id"

  create_table "memories_places", id: false, force: true do |t|
    t.integer "memory_id", null: false
    t.integer "place_id",  null: false
  end

  create_table "memories_ponds", id: false, force: true do |t|
    t.integer "memory_id"
    t.integer "pond_id"
  end

  create_table "memories_tackle_sets", id: false, force: true do |t|
    t.integer "memory_id",     null: false
    t.integer "tackle_set_id", null: false
  end

  create_table "memories_tackles", id: false, force: true do |t|
    t.integer "memory_id"
    t.integer "tackle_id"
  end

  create_table "places", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "pond_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "places", ["name", "pond_id", "user_id"], name: "index_places_on_name_and_pond_id_and_user_id", unique: true
  add_index "places", ["user_id"], name: "index_places_on_user_id"

  create_table "ponds", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  add_index "ponds", ["name", "user_id"], name: "index_ponds_on_name_and_user_id", unique: true
  add_index "ponds", ["user_id"], name: "index_ponds_on_user_id"

  create_table "tackle_sets", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  add_index "tackle_sets", ["name", "user_id"], name: "index_tackle_sets_on_name_and_user_id", unique: true
  add_index "tackle_sets", ["user_id"], name: "index_tackle_sets_on_user_id"

  create_table "tackle_sets_tackles", id: false, force: true do |t|
    t.integer "tackle_id",     null: false
    t.integer "tackle_set_id", null: false
  end

  create_table "tackles", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  add_index "tackles", ["name", "user_id"], name: "index_tackles_on_name_and_user_id", unique: true
  add_index "tackles", ["user_id"], name: "index_tackles_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.integer  "role"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
