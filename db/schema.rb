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

ActiveRecord::Schema.define(version: 2021_11_23_100645) do

  create_table "github_events", id: :string, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "type"
    t.json "actor"
    t.json "repo"
    t.json "org"
    t.json "payload"
    t.boolean "public"
    t.datetime "created_at"
    t.json "other"
    t.boolean "is_oss_db", default: false
    t.string "repo_id"
    t.string "repo_name"
    t.string "actor_id"
    t.string "actor_login"
    t.string "actor_location"
    t.string "language"
    t.bigint "additions"
    t.bigint "deletions"
    t.string "action"
    t.index ["action"], name: "index_github_events_on_action"
    t.index ["actor_id"], name: "index_github_events_on_actor_id"
    t.index ["actor_login"], name: "index_github_events_on_actor_login"
    t.index ["created_at"], name: "index_github_events_on_created_at"
    t.index ["is_oss_db"], name: "index_github_events_on_is_oss_db"
    t.index ["language"], name: "index_github_events_on_language"
    t.index ["repo_id"], name: "index_github_events_on_repo_id"
    t.index ["repo_name"], name: "index_github_events_on_repo_name"
    t.index ["type"], name: "index_github_events_on_type"
  end

  create_table "import_logs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "filename", null: false
    t.string "local_file"
    t.datetime "start_download_at"
    t.datetime "end_download_at"
    t.datetime "start_import_at"
    t.datetime "end_import_at"
    t.datetime "start_batch_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["filename"], name: "index_import_logs_on_filename"
  end

end
