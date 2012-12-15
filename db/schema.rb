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

ActiveRecord::Schema.define(:version => 20121212213321) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "boxes", :force => true do |t|
    t.string   "gender"
    t.string   "size"
    t.string   "status",                                     :default => "active"
    t.integer  "user_id"
    t.decimal  "seller_price", :precision => 8, :scale => 2
    t.decimal  "rating"
    t.string   "review"
    t.string   "notes"
    t.boolean  "is_featured",                                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "brands", :id => false, :force => true do |t|
    t.integer   "id",                      :null => false
    t.string    "name"
    t.string    "photo"
    t.timestamp "created_at", :limit => 6, :null => false
    t.timestamp "updated_at", :limit => 6, :null => false
    t.string    "slug"
    t.boolean   "has_image"
  end

  create_table "carts", :force => true do |t|
    t.integer "user_id"
  end

  add_index "carts", ["user_id"], :name => "index_carts_on_user_id"

  create_table "charities", :force => true do |t|
    t.string  "name"
    t.string  "site"
    t.string  "status"
    t.decimal "goal",    :precision => 8, :scale => 2
    t.decimal "balance", :precision => 8, :scale => 2
  end

  create_table "item_types", :force => true do |t|
    t.string  "name"
    t.string  "short_name"
    t.string  "category"
    t.integer "item_weight_id"
  end

  add_index "item_types", ["item_weight_id"], :name => "index_item_types_on_item_weight_id"

  create_table "item_weights", :force => true do |t|
    t.string "name"
    t.hstore "weights"
  end

  create_table "items", :force => true do |t|
    t.string  "gender"
    t.string  "size"
    t.boolean "new_with_tags"
    t.string  "status",                                      :default => "active"
    t.integer "user_id"
    t.integer "box_id"
    t.integer "item_type_id"
    t.integer "brand_id"
    t.string  "photo"
    t.decimal "price",         :precision => 8, :scale => 2
  end

  add_index "items", ["box_id"], :name => "index_items_on_box_id"
  add_index "items", ["brand_id"], :name => "index_items_on_brand_id"
  add_index "items", ["item_type_id"], :name => "index_items_on_item_type_id"
  add_index "items", ["user_id"], :name => "index_items_on_user_id"

  create_table "order_items", :force => true do |t|
    t.integer "box_id"
    t.integer "order_id"
    t.boolean "paid",           :default => false
    t.string  "status",         :default => "pending"
    t.string  "full_tracking"
    t.string  "empty_tracking"
  end

  add_index "order_items", ["box_id"], :name => "index_order_items_on_box_id", :unique => true
  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"

  create_table "orders", :force => true do |t|
    t.string   "stripe_charge_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price_total",      :precision => 8, :scale => 2, :null => false
    t.decimal  "boxes_total",      :precision => 8, :scale => 2, :null => false
  end

  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "photos", :force => true do |t|
    t.integer  "imageable_id"
    t.integer  "imageable_type"
    t.string   "image"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "thredup_data", :force => true do |t|
    t.string  "brand_name"
    t.string  "item_type"
    t.string  "gender"
    t.string  "size"
    t.decimal "thredup_price", :precision => 8, :scale => 2
    t.decimal "retail_price",  :precision => 8, :scale => 2
    t.boolean "new_with_tags",                               :default => false
    t.string  "url"
    t.integer "brand_id"
  end

  add_index "thredup_data", ["brand_id"], :name => "index_thredup_data_on_brand_id"
  add_index "thredup_data", ["url"], :name => "index_thredup_data_on_url"

  create_table "users", :force => true do |t|
    t.string       "email",                                                :default => "",  :null => false
    t.string       "encrypted_password",                                   :default => "",  :null => false
    t.string       "reset_password_token"
    t.datetime     "reset_password_sent_at"
    t.datetime     "remember_created_at"
    t.integer      "sign_in_count",                                        :default => 0
    t.datetime     "current_sign_in_at"
    t.datetime     "last_sign_in_at"
    t.string       "current_sign_in_ip"
    t.string       "last_sign_in_ip"
    t.string       "confirmation_token"
    t.datetime     "confirmed_at"
    t.datetime     "confirmation_sent_at"
    t.string       "unconfirmed_email"
    t.string       "authentication_token"
    t.datetime     "created_at",                                                            :null => false
    t.datetime     "updated_at",                                                            :null => false
    t.string       "username"
    t.string       "name"
    t.string       "slug"
    t.string       "gender"
    t.date         "birthday"
    t.string       "origin"
    t.integer      "credits"
    t.string       "stripe_customer_id"
    t.hstore       "address"
    t.string       "avatar"
    t.string       "fb_uid"
    t.string       "fb_secret"
    t.string       "fb_token"
    t.boolean      "fb_use_image"
    t.decimal      "balance",                :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.string_array "roles"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

  create_table "withdrawals", :force => true do |t|
    t.decimal  "amount",     :precision => 8, :scale => 2,                    :null => false
    t.hstore   "address",                                                     :null => false
    t.boolean  "sent",                                     :default => false, :null => false
    t.integer  "user_id"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
  end

  add_index "withdrawals", ["user_id"], :name => "index_withdrawals_on_user_id"

end
