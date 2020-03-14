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

ActiveRecord::Schema.define(version: 2020_03_11_020248) do

  create_table "articles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "shop_name"
    t.string "shop_url"
    t.string "address"
    t.string "image1"
    t.string "image2"
    t.string "image3"
    t.string "image4"
    t.string "image5"
    t.string "image6"
    t.string "area"
    t.string "station"
    t.integer "walk_time"
    t.string "main"
    t.string "alcohol_type"
    t.string "food_type"
    t.integer "budget"
    t.string "situation"
    t.string "softdrink"
    t.string "room_type"
    t.string "smoking"
    t.string "net_reservation"
    t.integer "review"
    t.string "comment"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "job_field"
    t.string "job_class"
    t.string "my_area1"
    t.string "my_area2"
    t.string "my_area3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
