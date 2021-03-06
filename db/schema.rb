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

ActiveRecord::Schema.define(version: 20150121053839) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: true do |t|
    t.integer  "match_id"
    t.integer  "score_1",  default: 0,                     null: false
    t.integer  "score_2",  default: 0,                     null: false
    t.datetime "date",     default: '2015-01-19 21:34:44', null: false
  end

  create_table "games_matches", id: false, force: true do |t|
    t.integer "game_id"
    t.integer "match_id"
  end

  create_table "matches", force: true do |t|
    t.integer  "team_1_id"
    t.integer  "team_2_id"
    t.datetime "date",               default: '2015-01-16 03:40:31', null: false
    t.integer  "team_1_player_1_id", default: 0,                     null: false
    t.integer  "team_1_player_2_id"
    t.integer  "team_2_player_1_id", default: 0,                     null: false
    t.integer  "team_2_player_2_id"
  end

  create_table "matches_players", id: false, force: true do |t|
    t.integer "match_id"
    t.integer "player_id"
  end

  create_table "player_ratings", force: true do |t|
    t.integer  "player_id",                                 null: false
    t.integer  "game_id",   default: 0,                     null: false
    t.float    "mean",      default: 25.0,                  null: false
    t.float    "deviation", default: 2.0,                   null: false
    t.float    "activity",  default: 1.0,                   null: false
    t.datetime "date",      default: '2015-01-19 21:34:44', null: false
  end

  create_table "players", force: true do |t|
    t.string  "first_name",                       null: false
    t.string  "last_name",                        null: false
    t.string  "email",             default: "",   null: false
    t.integer "match_wins",        default: 0
    t.integer "match_losses",      default: 0
    t.integer "game_wins",         default: 0
    t.integer "game_losses",       default: 0
    t.float   "trueskill",         default: 25.0
    t.integer "best_buddy_id",     default: 0
    t.integer "dynamic_duo_id",    default: 0
    t.integer "ball_and_chain_id", default: 0
    t.integer "rival_id",          default: 0
    t.integer "punching_bag_id",   default: 0
    t.integer "nemesis_id",        default: 0
  end

  create_table "teams", force: true do |t|
    t.integer "player_1_id"
    t.integer "player_2_id"
  end

end
