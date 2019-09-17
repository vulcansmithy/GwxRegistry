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

ActiveRecord::Schema.define(version: 2019_09_17_074700) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.float "fixed_amount"
    t.float "unit_fee"
    t.boolean "fixed"
    t.boolean "rate"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_actions_on_game_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_games", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "game_id", null: false
    t.index ["category_id", "game_id"], name: "index_categories_games_on_category_id_and_game_id", unique: true
  end

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "publisher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_application_id"
    t.json "images"
    t.text "platforms", default: [], array: true
    t.string "icon"
    t.string "url"
    t.string "cover"
    t.index ["game_application_id"], name: "index_games_on_game_application_id"
    t.index ["publisher_id"], name: "index_games_on_publisher_id"
  end

  create_table "games_tags", id: false, force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "tag_id", null: false
    t.index ["game_id", "tag_id"], name: "index_games_tags_on_game_id_and_tag_id", unique: true
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.string "owner_type"
    t.index ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "player_profiles", force: :cascade do |t|
    t.decimal "balance", precision: 8, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "game_id"
    t.index ["game_id"], name: "index_player_profiles_on_game_id"
    t.index ["user_id", "game_id"], name: "index_player_profiles_on_user_id_and_game_id", unique: true
    t.index ["user_id"], name: "index_player_profiles_on_user_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "wallet_address"
    t.string "description"
    t.decimal "balance", precision: 8, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "publisher_name"
    t.index ["publisher_name"], name: "index_publishers_on_publisher_name", unique: true
    t.index ["user_id"], name: "index_publishers_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "triggers", force: :cascade do |t|
    t.bigint "player_profile_id"
    t.bigint "action_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transaction_id"
    t.index ["action_id"], name: "index_triggers_on_action_id"
    t.index ["player_profile_id"], name: "index_triggers_on_player_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "confirmation_code"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "wallet_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_pk"
    t.string "encrypted_pk_iv"
    t.string "mac_address"
    t.string "device_token"
    t.datetime "reset_password_sent_at"
    t.string "temporary_password"
    t.string "avatar"
    t.string "username"
    t.datetime "last_login"
    t.index ["email", "mac_address", "confirmation_code"], name: "index_users_on_email_and_mac_address_and_confirmation_code", unique: true
    t.index ["encrypted_pk_iv"], name: "index_users_on_encrypted_pk_iv", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.string "wallet_address"
    t.string "wallet_type"
    t.string "account_type"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_pk"
    t.string "encrypted_pk_iv"
    t.string "encrypted_custodian_key"
    t.string "encrypted_custodian_key_iv"
    t.index ["account_type", "account_id"], name: "index_wallets_on_account_type_and_account_id"
    t.index ["encrypted_custodian_key_iv"], name: "index_wallets_on_encrypted_custodian_key_iv", unique: true
    t.index ["encrypted_pk_iv"], name: "index_wallets_on_encrypted_pk_iv", unique: true
    t.index ["wallet_address"], name: "index_wallets_on_wallet_address", unique: true
  end

  add_foreign_key "actions", "games"
  add_foreign_key "games", "publishers"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "player_profiles", "games"
  add_foreign_key "player_profiles", "users"
  add_foreign_key "publishers", "users"
  add_foreign_key "triggers", "actions"
  add_foreign_key "triggers", "player_profiles"
end
