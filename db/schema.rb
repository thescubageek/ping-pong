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

ActiveRecord::Schema.define(version: 20150331160140) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "g5_authenticatable_users", force: true do |t|
    t.string   "email",              default: "",   null: false
    t.string   "provider",           default: "g5", null: false
    t.string   "uid",                               null: false
    t.string   "g5_access_token"
    t.integer  "sign_in_count",      default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "g5_authenticatable_users", ["email"], name: "index_g5_authenticatable_users_on_email", unique: true, using: :btree
  add_index "g5_authenticatable_users", ["provider", "uid"], name: "index_g5_authenticatable_users_on_provider_and_uid", unique: true, using: :btree

  create_table "game_ratings", force: true do |t|
    t.integer  "player_id",                                 null: false
    t.integer  "game_id",   default: 0,                     null: false
    t.float    "mean",      default: 50.0,                  null: false
    t.float    "deviation", default: 2.0,                   null: false
    t.float    "activity",  default: 1.0,                   null: false
    t.datetime "date",      default: '2015-03-31 18:27:58', null: false
  end

  create_table "games", force: true do |t|
    t.integer  "match_id"
    t.integer  "score_1",     default: 0,       null: false
    t.integer  "score_2",     default: 0,       null: false
    t.datetime "date",        default: "now()", null: false
    t.integer  "player_1_id", default: 0,       null: false
    t.integer  "player_2_id", default: 0,       null: false
    t.integer  "winner_id",   default: 0,       null: false
    t.integer  "loser_id",    default: 0,       null: false
  end

  create_table "games_matches", id: false, force: true do |t|
    t.integer "game_id"
    t.integer "match_id"
  end

  create_table "match_ratings", force: true do |t|
    t.integer  "player_id",                                 null: false
    t.integer  "match_id",  default: 0,                     null: false
    t.float    "mean",      default: 50.0,                  null: false
    t.float    "deviation", default: 2.0,                   null: false
    t.float    "activity",  default: 1.0,                   null: false
    t.datetime "date",      default: '2015-03-31 18:27:58', null: false
  end

  create_table "matches", force: true do |t|
    t.datetime "date",        default: '2015-01-21 05:53:44', null: false
    t.integer  "player_1_id", default: 0,                     null: false
    t.integer  "player_2_id", default: 0,                     null: false
    t.integer  "winner_id",   default: 0,                     null: false
    t.integer  "loser_id",    default: 0,                     null: false
    t.integer  "score_1",     default: 0,                     null: false
    t.integer  "score_2",     default: 0,                     null: false
  end

  create_table "matches_players", id: false, force: true do |t|
    t.integer "match_id"
    t.integer "player_id"
  end

  create_table "players", force: true do |t|
    t.string  "first_name",                     null: false
    t.string  "last_name",                      null: false
    t.string  "email",           default: "",   null: false
    t.integer "match_wins",      default: 0
    t.integer "match_losses",    default: 0
    t.integer "game_wins",       default: 0
    t.integer "game_losses",     default: 0
    t.float   "trueskill",       default: 25.0
    t.integer "rival_id",        default: 0
    t.integer "punching_bag_id", default: 0
    t.integer "nemesis_id",      default: 0
  end

  create_table "xp_ratings", force: true do |t|
    t.integer  "player_id",                                 null: false
    t.integer  "match_id",  default: 0,                     null: false
    t.float    "value",     default: 0.1,                   null: false
    t.string   "name",      default: "Match XP",            null: false
    t.datetime "date",      default: '2015-03-31 18:28:08', null: false
  end

end
