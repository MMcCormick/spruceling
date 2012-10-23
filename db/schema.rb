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

ActiveRecord::Schema.define(:version => 20121019013716) do

  create_table "attachinary_files", :force => true do |t|
    t.integer  "attachinariable_id"
    t.string   "attachinariable_type"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "attachinary_files", ["attachinariable_type", "attachinariable_id", "scope"], :name => "by_scoped_parent"

  create_table "boxes", :force => true do |t|
    t.string  "gender"
    t.string  "size"
    t.string  "status",  :default => "active"
    t.integer "user_id"
  end

  create_table "boxes_carts", :id => false, :force => true do |t|
    t.integer "cart_id", :null => false
    t.integer "box_id",  :null => false
  end

  create_table "carts", :force => true do |t|
    t.integer "user_id"
  end

  create_table "item_types", :force => true do |t|
    t.string  "name"
    t.string  "short_name"
    t.string  "category"
    t.integer "item_weight_id"
  end

  create_table "item_weights", :force => true do |t|
    t.string "name"
    t.text   "weights"
  end

  create_table "items", :force => true do |t|
    t.string  "gender"
    t.string  "size"
    t.string  "brand"
    t.boolean "new_with_tags"
    t.string  "status",        :default => "active"
    t.integer "user_id"
    t.integer "box_id"
    t.integer "item_type_id"
  end

  create_table "order_items", :force => true do |t|
    t.integer "box_id"
    t.integer "order_id"
  end

  create_table "orders", :force => true do |t|
    t.string   "stripe_charge_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
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
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.integer  "credits"
    t.string   "stripe_customer_id"
    t.hstore   "address"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
