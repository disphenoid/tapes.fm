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

ActiveRecord::Schema.define(:version => 20120806173739) do

  create_table "attachments", :force => true do |t|
    t.string   "thumb"
    t.string   "attachment_type"
    t.integer  "hits"
    t.integer  "user_id"
    t.integer  "drop_id"
    t.string   "url"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "picture_meta"
  end

  create_table "comments", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "loves_count",      :default => 0
  end

  create_table "deeds", :force => true do |t|
    t.string   "uid"
    t.string   "action_de"
    t.string   "action_en"
    t.integer  "doo_count"
    t.string   "category"
    t.string   "tags"
    t.string   "supporter"
    t.boolean  "active"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "doos", :force => true do |t|
    t.string   "uid"
    t.integer  "user_id"
    t.integer  "deed_id"
    t.integer  "doo_id"
    t.integer  "doo_count"
    t.string   "ip"
    t.integer  "position"
    t.string   "region_name"
    t.string   "city"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "country_code"
    t.string   "country_name"
    t.integer  "mobile"
    t.integer  "loves_count"
    t.string   "category"
    t.text     "story"
    t.string   "link"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.text     "picture_meta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "inactive"
  end

  add_index "doos", ["inactive"], :name => "index_doos_on_inactive"

  create_table "drops", :force => true do |t|
    t.string   "uid"
    t.integer  "share_count",     :default => 0
    t.integer  "user_id"
    t.integer  "mission_id"
    t.string   "geo_ip"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "vendor_name"
    t.string   "region_name"
    t.string   "city"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "country_code3"
    t.string   "country_code"
    t.string   "country_name"
    t.integer  "mobile"
    t.integer  "loves_count"
    t.string   "attachment_type"
  end

  add_index "drops", ["address"], :name => "index_drops_on_address"
  add_index "drops", ["attachment_type"], :name => "index_drops_on_attachment_type"
  add_index "drops", ["city"], :name => "index_drops_on_city"
  add_index "drops", ["country_code"], :name => "index_drops_on_country_code"
  add_index "drops", ["country_code3"], :name => "index_drops_on_country_code3"
  add_index "drops", ["country_name"], :name => "index_drops_on_country_name"
  add_index "drops", ["latitude"], :name => "index_drops_on_latitude"
  add_index "drops", ["longitude"], :name => "index_drops_on_longitude"
  add_index "drops", ["loves_count"], :name => "index_drops_on_loves_count"
  add_index "drops", ["mobile"], :name => "index_drops_on_mobile"
  add_index "drops", ["region_name"], :name => "index_drops_on_region_name"
  add_index "drops", ["vendor_name"], :name => "index_drops_on_vendor_name"

  create_table "follows", :force => true do |t|
    t.integer  "source_id"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["source_id", "target_id"], :name => "index_follows_on_source_id_and_target_id", :unique => true
  add_index "follows", ["source_id"], :name => "index_follows_on_source_id"
  add_index "follows", ["target_id"], :name => "index_follows_on_target_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "color"
    t.text     "project"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loves", :force => true do |t|
    t.integer  "source_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "loves", ["source_id", "target_id", "target_type"], :name => "index_loves_on_source_id_and_target_id_and_target_type", :unique => true
  add_index "loves", ["source_id"], :name => "index_loves_on_source_id"
  add_index "loves", ["target_id", "target_type"], :name => "index_loves_on_target_id_and_target_type"

  create_table "mission_proposals", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "user_id"
  end

  create_table "missions", :force => true do |t|
    t.string   "uid"
    t.string   "group_id"
    t.text     "dailygood_en"
    t.text     "dailygood_de"
    t.text     "info_en"
    t.text     "info_de"
    t.date     "live_date"
    t.integer  "drop_count",               :default => 0
    t.date     "last_live_date"
    t.integer  "publisher_id"
    t.integer  "author_id"
    t.text     "submiter"
    t.text     "notes"
    t.text     "tags"
    t.integer  "level"
    t.string   "abstraction"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "story_teaser"
    t.string   "teaser_en"
    t.string   "teaser_de"
    t.string   "facebookpic_file_name"
    t.string   "facebookpic_content_type"
    t.integer  "facebookpic_file_size"
    t.datetime "facebookpic_updated_at"
  end

  add_index "missions", ["facebookpic_content_type"], :name => "index_missions_on_facebookpic_content_type"
  add_index "missions", ["facebookpic_file_name"], :name => "index_missions_on_facebookpic_file_name"
  add_index "missions", ["facebookpic_file_size"], :name => "index_missions_on_facebookpic_file_size"
  add_index "missions", ["facebookpic_updated_at"], :name => "index_missions_on_facebookpic_updated_at"
  add_index "missions", ["story_teaser"], :name => "index_missions_on_story_teaser"
  add_index "missions", ["teaser_de"], :name => "index_missions_on_teaser_de"
  add_index "missions", ["teaser_en"], :name => "index_missions_on_teaser_en"

  create_table "posts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "url_name"
    t.text     "description"
    t.text     "body"
    t.integer  "user_id"
    t.string   "facebookpic_file_name"
    t.string   "facebookpic_content_type"
    t.integer  "facebookpic_file_size"
    t.datetime "facebookpic_updated_at"
  end

  add_index "posts", ["facebookpic_content_type"], :name => "index_posts_on_facebookpic_content_type"
  add_index "posts", ["facebookpic_file_name"], :name => "index_posts_on_facebookpic_file_name"
  add_index "posts", ["facebookpic_file_size"], :name => "index_posts_on_facebookpic_file_size"
  add_index "posts", ["facebookpic_updated_at"], :name => "index_posts_on_facebookpic_updated_at"

  create_table "profiles", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.date     "birthday"
    t.string   "setting_daily_mission"
    t.string   "country"
    t.string   "city"
    t.string   "zip"
    t.string   "street"
    t.string   "language"
    t.text     "motivation"
    t.text     "philosophy"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text     "status"
    t.string   "uid"
    t.integer  "user_id"
    t.integer  "drop_count",                           :default => 0
    t.string   "public_website"
    t.string   "public_twitter"
    t.string   "public_facebook"
    t.string   "public_googleplus"
    t.string   "public_email"
    t.string   "gender"
    t.boolean  "setting_inactive",                     :default => false
    t.boolean  "setting_notification_comment_profile", :default => true
    t.boolean  "setting_notification_comment_story",   :default => true
    t.boolean  "setting_notification_follower_new",    :default => true
    t.boolean  "setting_notification_follower_story",  :default => true
    t.boolean  "setting_hidde_profile_comment",        :default => false
    t.boolean  "setting_show_only_firstname",          :default => false
    t.boolean  "setting_hide_search"
  end

  add_index "profiles", ["gender"], :name => "index_profiles_on_gender"
  add_index "profiles", ["public_email"], :name => "index_profiles_on_public_email"
  add_index "profiles", ["public_facebook"], :name => "index_profiles_on_public_facebook"
  add_index "profiles", ["public_googleplus"], :name => "index_profiles_on_public_googleplus"
  add_index "profiles", ["public_twitter"], :name => "index_profiles_on_public_twitter"
  add_index "profiles", ["public_website"], :name => "index_profiles_on_public_website"
  add_index "profiles", ["setting_hidde_profile_comment"], :name => "index_profiles_on_setting_hidde_profile_comment"
  add_index "profiles", ["setting_hide_search"], :name => "index_profiles_on_setting_hide_search"
  add_index "profiles", ["setting_inactive"], :name => "index_profiles_on_setting_inactive"
  add_index "profiles", ["setting_notification_comment_profile"], :name => "index_profiles_on_setting_notification_comment_profile"
  add_index "profiles", ["setting_notification_comment_story"], :name => "index_profiles_on_setting_notification_comment_story"
  add_index "profiles", ["setting_notification_follower_new"], :name => "index_profiles_on_setting_notification_follower_new"
  add_index "profiles", ["setting_notification_follower_story"], :name => "index_profiles_on_setting_notification_follower_story"
  add_index "profiles", ["setting_show_only_firstname"], :name => "index_profiles_on_setting_show_only_firstname"

  create_table "rewards", :force => true do |t|
    t.integer  "deed_id"
    t.integer  "user_id"
    t.string   "client"
    t.text     "body"
    t.text     "codes"
    t.integer  "code_count"
    t.integer  "views"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  add_index "services", ["token"], :name => "index_services_on_token"

  create_table "social_activities", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.date     "from_date"
    t.date     "to_date"
    t.string   "title"
    t.string   "link"
    t.boolean  "to_present"
    t.integer  "profile_id"
  end

  create_table "sponsors", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stories", :force => true do |t|
    t.integer  "drop_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "loves_count", :default => 0
  end

  create_table "tapes", :force => true do |t|
    t.string   "name"
    t.integer  "bpm"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",                  :default => ""
    t.string   "password_salt",                       :default => ""
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.string   "login"
    t.integer  "uid",                   :limit => 8
    t.boolean  "admin"
    t.integer  "drop_count",                          :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token",      :limit => 20
    t.datetime "invitation_sent_at"
    t.integer  "follows_count",                       :default => 0
    t.boolean  "newsletter"
    t.integer  "earned_loves_count",                  :default => 0
    t.boolean  "terms",                               :default => false
    t.integer  "user_first_drop"
    t.string   "gender"
    t.string   "facebook_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "language"
    t.integer  "group_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text     "avatar_meta"
    t.string   "vendor_name"
    t.string   "region_name"
    t.string   "city"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "country_code"
    t.string   "country_name"
    t.integer  "inspired_count",                      :default => 0
    t.integer  "doo_count",                           :default => 0
    t.boolean  "setting_f_connect"
    t.boolean  "setting_n_doo_comment",               :default => true
    t.boolean  "setting_n_follows",                   :default => true
    t.boolean  "setting_n_deed",                      :default => true
  end

  add_index "users", ["address"], :name => "index_users_on_address"
  add_index "users", ["avatar_content_type"], :name => "index_users_on_avatar_content_type"
  add_index "users", ["avatar_file_name"], :name => "index_users_on_avatar_file_name"
  add_index "users", ["avatar_file_size"], :name => "index_users_on_avatar_file_size"
  add_index "users", ["avatar_meta"], :name => "index_users_on_avatar_meta"
  add_index "users", ["avatar_updated_at"], :name => "index_users_on_avatar_updated_at"
  add_index "users", ["city"], :name => "index_users_on_city"
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["country_code"], :name => "index_users_on_country_code"
  add_index "users", ["country_name"], :name => "index_users_on_country_name"
  add_index "users", ["doo_count"], :name => "index_users_on_doo_count"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["facebook_id"], :name => "index_users_on_facebook_id"
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["gender"], :name => "index_users_on_gender"
  add_index "users", ["group_id"], :name => "index_users_on_group_id"
  add_index "users", ["inspired_count"], :name => "index_users_on_inspired_count"
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["language"], :name => "index_users_on_language"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["latitude"], :name => "index_users_on_latitude"
  add_index "users", ["longitude"], :name => "index_users_on_longitude"
  add_index "users", ["newsletter"], :name => "index_users_on_newsletter"
  add_index "users", ["region_name"], :name => "index_users_on_region_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["setting_f_connect"], :name => "index_users_on_setting_f_connect"
  add_index "users", ["setting_n_deed"], :name => "index_users_on_setting_n_deed"
  add_index "users", ["setting_n_doo_comment"], :name => "index_users_on_setting_n_doo_comment"
  add_index "users", ["setting_n_follows"], :name => "index_users_on_setting_n_follows"
  add_index "users", ["terms"], :name => "index_users_on_terms"
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true
  add_index "users", ["user_first_drop"], :name => "index_users_on_user_first_drop"
  add_index "users", ["vendor_name"], :name => "index_users_on_vendor_name"

end
