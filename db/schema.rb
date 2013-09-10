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

ActiveRecord::Schema.define(version: 20130909213225) do

  create_table "branches", force: true do |t|
    t.integer  "branch_id",                null: false
    t.string   "name",                     null: false
    t.string   "address"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "branches", ["branch_id"], name: "index_branches_on_branch_id", unique: true, using: :btree

  create_table "branches_users", force: true do |t|
    t.integer  "branch_id",  null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "branches_users", ["branch_id"], name: "index_branches_users_on_branch_id", using: :btree
  add_index "branches_users", ["user_id"], name: "index_branches_users_on_user_id", using: :btree

  create_table "clients", force: true do |t|
    t.string   "name",                       null: false
    t.string   "lastname",                   null: false
    t.string   "identification",             null: false
    t.string   "address"
    t.integer  "lock_version",   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["identification"], name: "index_clients_on_identification", unique: true, using: :btree
  add_index "clients", ["lastname"], name: "index_clients_on_lastname", using: :btree
  add_index "clients", ["name"], name: "index_clients_on_name", using: :btree

  create_table "comments", force: true do |t|
    t.text     "comment",                  null: false
    t.integer  "loan_id",                  null: false
    t.integer  "user_id",                  null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["loan_id"], name: "index_comments_on_loan_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "loans", force: true do |t|
    t.integer  "loan_id",                                                           null: false
    t.decimal  "capital",                  precision: 15, scale: 5
    t.decimal  "payment",                  precision: 15, scale: 5
    t.decimal  "total_debt",               precision: 15, scale: 5
    t.integer  "days_overdue_average"
    t.integer  "expired_payments_count"
    t.integer  "payments_to_expire_count"
    t.integer  "payments_count"
    t.integer  "progress"
    t.date     "delayed_at"
    t.date     "next_payment_expire_at"
    t.integer  "client_id"
    t.integer  "user_id"
    t.integer  "branch_id"
    t.integer  "zone_id"
    t.integer  "lock_version",                                      default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "canceled_at"
    t.integer  "segment_id"
    t.boolean  "debtor",                                            default: false, null: false
  end

  add_index "loans", ["branch_id"], name: "index_loans_on_branch_id", using: :btree
  add_index "loans", ["canceled_at"], name: "index_loans_on_canceled_at", using: :btree
  add_index "loans", ["client_id"], name: "index_loans_on_client_id", using: :btree
  add_index "loans", ["days_overdue_average"], name: "index_loans_on_days_overdue_average", using: :btree
  add_index "loans", ["debtor"], name: "index_loans_on_debtor", using: :btree
  add_index "loans", ["delayed_at"], name: "index_loans_on_delayed_at", using: :btree
  add_index "loans", ["loan_id"], name: "index_loans_on_loan_id", unique: true, using: :btree
  add_index "loans", ["progress"], name: "index_loans_on_progress", using: :btree
  add_index "loans", ["segment_id"], name: "index_loans_on_segment_id", using: :btree
  add_index "loans", ["total_debt"], name: "index_loans_on_total_debt", using: :btree
  add_index "loans", ["user_id"], name: "index_loans_on_user_id", using: :btree
  add_index "loans", ["zone_id"], name: "index_loans_on_zone_id", using: :btree

  create_table "notes", force: true do |t|
    t.text     "note",                      null: false
    t.integer  "noteable_id",               null: false
    t.string   "noteable_type",             null: false
    t.integer  "lock_version",  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                   null: false
  end

  add_index "notes", ["noteable_id", "noteable_type"], name: "index_notes_on_noteable_id_and_noteable_type", using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "payments", force: true do |t|
    t.integer  "number",                                            null: false
    t.integer  "days_overdue"
    t.date     "expired_at",                                        null: false
    t.datetime "paid_at"
    t.decimal  "amount_paid",  precision: 15, scale: 5
    t.decimal  "total_paid",   precision: 15, scale: 5
    t.integer  "loan_id",                                           null: false
    t.integer  "user_id"
    t.integer  "lock_version",                          default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["expired_at"], name: "index_payments_on_expired_at", using: :btree
  add_index "payments", ["loan_id"], name: "index_payments_on_loan_id", using: :btree
  add_index "payments", ["number"], name: "index_payments_on_number", using: :btree
  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "phones", force: true do |t|
    t.string   "phone",                    null: false
    t.string   "carrier"
    t.integer  "client_id",                null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phones", ["client_id"], name: "index_phones_on_client_id", using: :btree

  create_table "reminders", force: true do |t|
    t.datetime "remind_at",                    null: false
    t.string   "kind",                         null: false
    t.boolean  "notified",     default: false, null: false
    t.boolean  "scheduled",    default: false, null: false
    t.integer  "schedule_id",                  null: false
    t.integer  "lock_version", default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reminders", ["schedule_id"], name: "index_reminders_on_schedule_id", using: :btree

  create_table "schedules", force: true do |t|
    t.text     "description",                      null: false
    t.datetime "scheduled_at",                     null: false
    t.boolean  "done",             default: false, null: false
    t.integer  "user_id",                          null: false
    t.integer  "schedulable_id"
    t.string   "schedulable_type"
    t.integer  "lock_version",     default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedules", ["schedulable_id", "schedulable_type"], name: "index_schedules_on_schedulable_id_and_schedulable_type", using: :btree
  add_index "schedules", ["scheduled_at"], name: "index_schedules_on_scheduled_at", using: :btree
  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id", using: :btree

  create_table "segments", force: true do |t|
    t.string   "segment_id",        null: false
    t.string   "description"
    t.string   "short_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "segments", ["segment_id"], name: "index_segments_on_segment_id", unique: true, using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id",                    null: false
    t.integer  "taggable_id",               null: false
    t.string   "taggable_type",             null: false
    t.integer  "lock_version",  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type"], name: "index_taggings_on_taggable_id_and_taggable_type", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name",                      null: false
    t.string   "category",                  null: false
    t.integer  "path",         default: [],              array: true
    t.integer  "user_id",                   null: false
    t.integer  "lock_version", default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "branch_id"
  end

  add_index "tags", ["branch_id"], name: "index_tags_on_branch_id", using: :btree
  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree
  add_index "tags", ["path"], name: "index_tags_on_path", using: :gin
  add_index "tags", ["user_id"], name: "index_tags_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                                null: false
    t.string   "username",                            null: false
    t.integer  "file_number"
    t.string   "identification"
    t.datetime "started_at"
    t.integer  "branch_id"
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
    t.integer  "path",                   default: [],              array: true
  end

  add_index "users", ["branch_id"], name: "index_users_on_branch_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["path"], name: "index_users_on_path", using: :gin
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.integer  "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["whodunnit"], name: "index_versions_on_whodunnit", using: :btree

  create_table "zones", force: true do |t|
    t.string   "zone_id",                  null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "branch_id"
  end

  add_index "zones", ["branch_id"], name: "index_zones_on_branch_id", using: :btree
  add_index "zones", ["name"], name: "index_zones_on_name", using: :btree
  add_index "zones", ["zone_id"], name: "index_zones_on_zone_id", unique: true, using: :btree

end
