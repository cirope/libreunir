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

ActiveRecord::Schema.define(version: 20130326173043) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "street"
    t.integer  "number"
    t.integer  "floor"
    t.string   "location"
    t.integer  "postal_code"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
    t.string   "address"
  end

  create_table "branches", force: true do |t|
    t.integer  "zone_id"
    t.string   "name"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "branches", ["zone_id"], name: "index_branches_on_zone_id"

  create_table "calls", force: true do |t|
    t.integer  "client_id"
    t.text     "call"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: true do |t|
    t.string   "name"
    t.string   "identification"
    t.integer  "lock_version",   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
  end

  create_table "fees", force: true do |t|
    t.decimal  "amount",          precision: 23, scale: 8
    t.datetime "expiration_date"
    t.datetime "payment_date"
    t.integer  "lock_version",                             default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fee_number"
    t.decimal  "total_amount"
    t.integer  "loan_id"
    t.string   "paid_to"
  end

  create_table "loans", force: true do |t|
    t.integer  "order_id"
    t.decimal  "amount",            precision: 23, scale: 8
    t.datetime "grant_date"
    t.datetime "expiration_date"
    t.integer  "lock_version",                               default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fund_id"
    t.decimal  "amount_to_finance"
    t.decimal  "capital"
    t.integer  "number_of_fees"
  end

  add_index "loans", ["order_id"], name: "index_loans_on_order_id"

  create_table "orders", force: true do |t|
    t.integer  "order_id"
    t.string   "adviser_id"
    t.string   "segment_id"
    t.integer  "branch_id"
    t.string   "zone_id"
    t.string   "assigned_adviser_id"
    t.integer  "lock_version",        default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_id"
  end

  add_index "orders", ["adviser_id"], name: "index_orders_on_adviser_id"
  add_index "orders", ["branch_id"], name: "index_orders_on_branch_id"
  add_index "orders", ["order_id"], name: "index_orders_on_order_id"
  add_index "orders", ["segment_id"], name: "index_orders_on_segment_id"
  add_index "orders", ["zone_id"], name: "index_orders_on_zone_id"

  create_table "parameters", force: true do |t|
    t.decimal  "rate",         precision: 23, scale: 8
    t.integer  "lock_version",                          default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", force: true do |t|
    t.integer  "client_id"
    t.string   "phone"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phones", ["client_id"], name: "index_phones_on_client_id"

  create_table "products", force: true do |t|
    t.string   "product_id"
    t.integer  "branch_id"
    t.datetime "delay_date"
    t.decimal  "expired_debt",   precision: 23, scale: 8
    t.decimal  "total_debt",     precision: 23, scale: 8
    t.integer  "expired_fees"
    t.integer  "fees_to_expire"
    t.integer  "lock_version",                            default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["branch_id"], name: "index_products_on_branch_id"

  create_table "relations", force: true do |t|
    t.string   "relation"
    t.integer  "user_id"
    t.integer  "relative_id"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "segments", force: true do |t|
    t.string   "segment_id"
    t.string   "description"
    t.integer  "status"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name",                                null: false
    t.string   "lastname"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "roles_mask",             default: 0,  null: false
    t.integer  "lock_version",           default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "adviser_id"
    t.string   "branch_id"
    t.string   "bundle"
    t.string   "identification"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["lastname"], name: "index_users_on_lastname"
  add_index "users", ["name"], name: "index_users_on_name"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.integer  "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  add_index "versions", ["whodunnit"], name: "index_versions_on_whodunnit"

  create_table "zones", force: true do |t|
    t.string   "name"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
