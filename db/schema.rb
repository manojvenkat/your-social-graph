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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150505181150) do

  create_table "connections", :force => true do |t|
    t.string   "name"
    t.string   "id_str"
    t.string   "screen_name"
    t.string   "keywords"
    t.string   "location"
    t.integer  "conn_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
    t.string   "longitude"
    t.string   "latitude"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "matchings", :force => true do |t|
    t.integer  "conn_1_id"
    t.integer  "conn_2_id"
    t.float    "match_percent"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "tweets", :force => true do |t|
    t.string   "ref_obj_type"
    t.integer  "ref_obj_id"
    t.string   "tweet_content"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "user_id"
    t.integer  "connection_id"
    t.boolean  "analyzed",      :default => false
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image_url"
    t.string   "oauth_secret"
    t.string   "twitter_handle"
    t.string   "keywords"
  end

end
