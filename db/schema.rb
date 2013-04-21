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

ActiveRecord::Schema.define(version: 20130420222515) do

  create_table "branches", force: true do |t|
    t.integer  "branch_id",  null: false
    t.string   "name",       null: false
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "branches", ["branch_id"], name: "index_branches_on_branch_id", unique: true

  create_table "clients", force: true do |t|
    t.string   "name",                                 null: false
    t.string   "lastname",                             null: false
    t.integer  "identification", limit: 8,             null: false
    t.string   "address"
    t.string   "phone"
    t.integer  "lock_version",             default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["identification"], name: "index_clients_on_identification", unique: true
  add_index "clients", ["lastname"], name: "index_clients_on_lastname"
  add_index "clients", ["name"], name: "index_clients_on_name"

  create_table "comments", force: true do |t|
    t.text     "comment",    null: false
    t.integer  "client_id",  null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["client_id"], name: "index_comments_on_client_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "payments", force: true do |t|
    t.integer  "number",                                             null: false
    t.datetime "expiration",                                         null: false
    t.datetime "payment_date"
    t.decimal  "amount_paid",  precision: 15, scale: 10
    t.decimal  "total",        precision: 15, scale: 10
    t.integer  "product_id",                                         null: false
    t.integer  "user_id"
    t.integer  "lock_version",                           default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["expiration"], name: "index_payments_on_expiration"
  add_index "payments", ["number"], name: "index_payments_on_number"
  add_index "payments", ["product_id"], name: "index_payments_on_product_id"
  add_index "payments", ["user_id"], name: "index_payments_on_user_id"

  create_table "products", force: true do |t|
    t.integer  "product_id",                                          null: false
    t.datetime "delay_date"
    t.decimal  "expired_debt",   precision: 20, scale: 5
    t.decimal  "total_debt",     precision: 20, scale: 5
    t.decimal  "debt_to_expire", precision: 20, scale: 5
    t.integer  "delay_maximum"
    t.integer  "client_id"
    t.integer  "branch_id"
    t.integer  "lock_version",                            default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["branch_id"], name: "index_products_on_branch_id"
  add_index "products", ["client_id"], name: "index_products_on_client_id"
  add_index "products", ["product_id"], name: "index_products_on_product_id", unique: true

  create_table "users", force: true do |t|
    t.string   "name",                                          null: false
    t.string   "username",                                      null: false
    t.integer  "file_number"
    t.integer  "identification",         limit: 8
    t.datetime "date_entry"
    t.integer  "branch_id",                                     null: false
    t.string   "email",                            default: "", null: false
    t.string   "encrypted_password",               default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "roles_mask",                       default: 0,  null: false
    t.integer  "lock_version",                     default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["branch_id"], name: "index_users_on_branch_id"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

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

end
