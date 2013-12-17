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

ActiveRecord::Schema.define(version: 20131122132811) do

  create_table "features", force: true do |t|
    t.string   "name"
    t.string   "nick"
    t.integer  "used",         default: 0
    t.integer  "total",        default: 0
    t.string   "custom_color"
    t.boolean  "visible",      default: true
    t.datetime "since"
    t.datetime "last_seen_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tokens", force: true do |t|
    t.integer  "feature_id"
    t.integer  "user_id"
    t.integer  "workstation_id"
    t.integer  "pid"
    t.integer  "count"
    t.string   "signature"
    t.integer  "slot"
    t.integer  "duration"
    t.datetime "start_at"
    t.datetime "stop_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usages", force: true do |t|
    t.integer  "feature_id"
    t.integer  "total",      default: 0
    t.integer  "used",       default: 0
    t.integer  "duration"
    t.float    "usage"
    t.float    "wu"
    t.datetime "start_at"
    t.datetime "stop_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "uid"
    t.string   "fullname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workstations", force: true do |t|
    t.string   "hostname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
