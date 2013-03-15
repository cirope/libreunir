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

ActiveRecord::Schema.define(:version => 20130315154402) do

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.integer  "number"
    t.integer  "floor"
    t.string   "location"
    t.integer  "postal_code"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "product_id"
    t.string   "address"
  end

  create_table "advisers", :force => true do |t|
    t.string   "name"
    t.string   "lastname"
    t.string   "identification"
    t.integer  "branch_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "adviser_id"
    t.string   "description"
    t.string   "bundle"
  end

  add_index "advisers", ["branch_id"], :name => "index_advisers_on_branch_id"

  create_table "branches", :force => true do |t|
    t.integer  "zone_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "branches", ["zone_id"], :name => "index_branches_on_zone_id"

  create_table "calls", :force => true do |t|
    t.string   "product_id"
    t.text     "call"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "identification"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "product_id"
  end

  create_table "fees", :force => true do |t|
    t.integer  "loan_id"
    t.decimal  "amount",          :precision => 23, :scale => 8
    t.datetime "expiration_date"
    t.datetime "payment_date"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "fee_number"
    t.decimal  "total_amount"
    t.string   "client_id"
  end

  add_index "fees", ["loan_id"], :name => "index_fees_on_loan_id"

  create_table "loans", :force => true do |t|
    t.integer  "client_id"
    t.integer  "adviser_id"
    t.decimal  "amount",            :precision => 23, :scale => 8
    t.datetime "grant_date"
    t.datetime "expiration_date"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "product_id"
    t.integer  "fund_id"
    t.decimal  "amount_to_finance"
    t.decimal  "capital"
    t.integer  "number_of_fees"
  end

  add_index "loans", ["adviser_id"], :name => "index_loans_on_adviser_id"
  add_index "loans", ["client_id"], :name => "index_loans_on_client_id"

  create_table "orders", :force => true do |t|
    t.integer  "order_id"
    t.string   "adviser_id"
    t.string   "segment_id"
    t.integer  "branch_id"
    t.string   "zone_id"
    t.string   "assigned_adviser_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "orders", ["adviser_id"], :name => "index_orders_on_adviser_id"
  add_index "orders", ["branch_id"], :name => "index_orders_on_branch_id"
  add_index "orders", ["order_id"], :name => "index_orders_on_order_id"
  add_index "orders", ["segment_id"], :name => "index_orders_on_segment_id"
  add_index "orders", ["zone_id"], :name => "index_orders_on_zone_id"

  create_table "parameters", :force => true do |t|
    t.decimal  "rate",       :precision => 23, :scale => 8
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "phones", :force => true do |t|
    t.integer  "client_id"
    t.string   "number"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "phones", ["client_id"], :name => "index_phones_on_client_id"

  create_table "products", :force => true do |t|
    t.string   "product_id"
    t.integer  "branch_id"
    t.datetime "delay_date"
    t.decimal  "expired_debt",   :precision => 23, :scale => 8
    t.decimal  "total_debt",     :precision => 23, :scale => 8
    t.integer  "expired_fees"
    t.integer  "fees_to_expire"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "products", ["branch_id"], :name => "index_products_on_branch_id"

  create_table "segments", :force => true do |t|
    t.string   "segment_id"
    t.string   "description"
    t.integer  "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                   :null => false
    t.string   "lastname"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "roles_mask",             :default => 0,  :null => false
    t.integer  "lock_version",           :default => 0,  :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["lastname"], :name => "index_users_on_lastname"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.integer  "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"
  add_index "versions", ["whodunnit"], :name => "index_versions_on_whodunnit"

  create_table "zones", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
