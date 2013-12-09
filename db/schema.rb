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

ActiveRecord::Schema.define(version: 20131209010826) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "feed_status", force: true do |t|
    t.string "name",  null: false
    t.string "label", null: false
  end

  create_table "feeds", force: true do |t|
    t.string   "name",            null: false
    t.text     "url",             null: false
    t.datetime "last_fetched_at"
    t.integer  "feed_status_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feeds", ["url"], name: "index_feeds_on_url", unique: true, using: :btree

  create_table "stories", force: true do |t|
    t.text     "title"
    t.text     "permalink"
    t.text     "body"
    t.text     "entry_id"
    t.integer  "feed_id",                     null: false
    t.datetime "published"
    t.boolean  "is_read",     default: false, null: false
    t.boolean  "is_stared",   default: false, null: false
    t.boolean  "keep_unread", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stories", ["permalink", "feed_id"], name: "index_stories_on_permalink_and_feed_id", unique: true, using: :btree

end
