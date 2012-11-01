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

ActiveRecord::Schema.define(:version => 20121030170213) do

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
    t.string  "status",                                     :default => "active"
    t.integer "user_id"
    t.decimal "seller_price", :precision => 8, :scale => 2
  end

  add_index "boxes", ["size"], :name => "index_boxes_on_size"
  add_index "boxes", ["user_id"], :name => "index_boxes_on_user_id"

  create_table "boxes_carts", :id => false, :force => true do |t|
    t.integer "cart_id", :null => false
    t.integer "box_id",  :null => false
  end

  add_index "boxes_carts", ["box_id"], :name => "index_boxes_carts_on_box_id"
  add_index "boxes_carts", ["cart_id", "box_id"], :name => "index_boxes_carts_on_cart_id_and_box_id", :unique => true
  add_index "boxes_carts", ["cart_id"], :name => "index_boxes_carts_on_cart_id"

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "carts", :force => true do |t|
    t.integer "user_id"
  end

  add_index "carts", ["user_id"], :name => "index_carts_on_user_id"

  create_table "item_types", :force => true do |t|
    t.string  "name"
    t.string  "short_name"
    t.string  "category"
    t.integer "item_weight_id"
  end

  add_index "item_types", ["item_weight_id"], :name => "index_item_types_on_item_weight_id"

  create_table "item_weights", :force => true do |t|
    t.string "name"
    t.text   "weights"
  end

  create_table "items", :force => true do |t|
    t.string  "gender"
    t.string  "size"
    t.boolean "new_with_tags"
    t.string  "status",        :default => "active"
    t.integer "user_id"
    t.integer "box_id"
    t.integer "item_type_id"
    t.integer "brand_id"
  end

  add_index "items", ["box_id"], :name => "index_items_on_box_id"
  add_index "items", ["brand_id"], :name => "index_items_on_brand_id"
  add_index "items", ["item_type_id"], :name => "index_items_on_item_type_id"
  add_index "items", ["user_id"], :name => "index_items_on_user_id"

  create_table "order_items", :force => true do |t|
    t.integer "box_id"
    t.integer "order_id"
  end

  add_index "order_items", ["box_id"], :name => "index_order_items_on_box_id", :unique => true
  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"

  create_table "orders", :force => true do |t|
    t.string   "stripe_charge_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price_total",      :precision => 8, :scale => 2, :null => false
  end

  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "thredup_data", :force => true do |t|
    t.string  "brand"
    t.string  "item_type"
    t.string  "gender"
    t.string  "size"
    t.decimal "thredup_price", :precision => 8, :scale => 2
    t.decimal "retail_price",  :precision => 8, :scale => 2
    t.boolean "new_with_tags",                               :default => false
    t.string  "url"
  end

  add_index "thredup_data", ["url"], :name => "index_thredup_data_on_url"

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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username"
    t.string   "name"
    t.string   "slug"
    t.string   "gender"
    t.date     "birthday"
    t.string   "origin"
    t.integer  "credits"
    t.string   "stripe_customer_id"
    t.hstore   "address"
    t.string   "fb_uid"
    t.string   "fb_secret"
    t.string   "fb_token"
    t.boolean  "fb_use_image"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

end
