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

ActiveRecord::Schema.define(:version => 20110224145241) do

  create_table "appliances", :force => true do |t|
    t.string   "name",       :limit => 100,   :null => false
    t.string   "state",      :limit => 20,    :null => false
    t.string   "definition", :limit => 10000, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appliances", ["name"], :name => "index_appliances_on_name", :unique => true

  create_table "images", :force => true do |t|
    t.integer  "appliance_id",               :null => false
    t.integer  "node_id"
    t.integer  "parent_id"
    t.string   "state",        :limit => 20, :null => false
    t.string   "platform",     :limit => 20
    t.string   "arch",         :limit => 10, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nodes", :force => true do |t|
    t.string   "name",         :limit => 100, :null => false
    t.string   "state",        :limit => 20,  :null => false
    t.string   "address",      :limit => 30,  :null => false
    t.string   "capabilities", :limit => 200, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
