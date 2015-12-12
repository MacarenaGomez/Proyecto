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

ActiveRecord::Schema.define(version: 20151212174327) do

  create_table "experts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "knowledges", force: :cascade do |t|
    t.integer  "expert_id"
    t.integer  "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "knowledges", ["expert_id"], name: "index_knowledges_on_expert_id"
  add_index "knowledges", ["topic_id"], name: "index_knowledges_on_topic_id"

  create_table "profiles", force: :cascade do |t|
    t.integer  "expert_id"
    t.string   "url"
    t.string   "profile_image_url"
    t.string   "location"
    t.text     "description"
    t.string   "profile_types"
    t.string   "screen_name"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "profiles", ["expert_id"], name: "index_profiles_on_expert_id"

  create_table "resources", force: :cascade do |t|
    t.integer  "tweet_id"
    t.string   "source_type"
    t.string   "source"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "resources", ["tweet_id"], name: "index_resources_on_tweet_id"

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tweets", force: :cascade do |t|
    t.integer  "expert_id"
    t.string   "text"
    t.integer  "rate"
    t.date     "date"
    t.string   "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tweets", ["expert_id"], name: "index_tweets_on_expert_id"

  create_table "twitter_apis", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
