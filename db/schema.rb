# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_12_23_021741) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "title", null: false
    t.integer "total_height", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "goals", force: :cascade do |t|
    t.string "title", null: false
    t.string "discription"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "index_goals_on_category_id"
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "height_histories", force: :cascade do |t|
    t.integer "reached_height", null: false
    t.integer "all_total_height", null: false
    t.bigint "user_id", null: false
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_height_histories_on_task_id"
    t.index ["user_id"], name: "index_height_histories_on_user_id"
  end

  create_table "heights", force: :cascade do |t|
    t.integer "current_height", null: false
    t.integer "current_height_level", null: false
    t.integer "max_height", null: false
    t.integer "max_height_level", null: false
    t.bigint "user_id", null: false
    t.bigint "goal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_heights_on_goal_id"
    t.index ["user_id"], name: "index_heights_on_user_id"
  end

  create_table "landmarks", force: :cascade do |t|
    t.string "name", null: false
    t.string "landmark_image", null: false
    t.integer "setting_height", null: false
    t.integer "setting_height_level", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.datetime "deadline"
    t.integer "access_level", default: 0, null: false
    t.integer "progress_status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "goal_id", null: false
    t.index ["goal_id"], name: "index_tasks_on_goal_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "user_name", null: false
    t.string "avater_image"
    t.string "profile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "categories", "users"
  add_foreign_key "goals", "categories"
  add_foreign_key "goals", "users"
  add_foreign_key "height_histories", "tasks"
  add_foreign_key "height_histories", "users"
  add_foreign_key "heights", "goals"
  add_foreign_key "heights", "users"
  add_foreign_key "tasks", "goals"
  add_foreign_key "tasks", "users"
end
