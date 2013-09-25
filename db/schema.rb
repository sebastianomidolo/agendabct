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

ActiveRecord::Schema.define(:version => 20130902143752) do

  create_table "event_attributes", :id => false, :force => true do |t|
    t.integer "event_id"
    t.string  "attribute_label"
    t.string  "content_class"
    t.text    "content"
  end

  create_table "events", :force => true do |t|
    t.integer "excel_sheet_id"
    t.string  "excel_source"
    t.text    "title"
    t.text    "description"
    t.text    "extra_description"
    t.integer "venue_id"
  end

  create_table "excel_sheets", :force => true do |t|
    t.string  "title"
    t.string  "filename"
    t.string  "anno"
    t.integer "numseq"
  end

  create_table "venues", :force => true do |t|
    t.string "name"
  end

end
