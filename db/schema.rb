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

ActiveRecord::Schema.define(version: 20160614110221) do

  create_table "addresses", force: true do |t|
    t.string   "line1"
    t.string   "line2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", unique: true

  create_table "clients", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "regon"
    t.string   "pesel"
    t.string   "nip"
    t.string   "invoice_currency"
    t.string   "freight_currency"
    t.integer  "payment_term"
    t.string   "invoice_language"
  end

  create_table "contacts", force: true do |t|
    t.string   "phone1"
    t.string   "phone2"
    t.string   "fax"
    t.string   "email"
    t.string   "www"
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable_type_and_contactable_id", unique: true

  create_table "invoice_items", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_names", force: true do |t|
    t.integer  "number"
    t.integer  "month"
    t.integer  "year"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_names", ["invoice_id"], name: "index_invoice_names_on_invoice_id"

  create_table "invoices", force: true do |t|
    t.datetime "date"
    t.integer  "client_id"
    t.integer  "seller_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.string   "name"
    t.string   "pkwiu"
    t.string   "unit"
    t.integer  "quantity"
    t.integer  "tax"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_cents",         default: 0,     null: false
    t.string   "price_currency",      default: "EUR", null: false
    t.integer  "unit_price_cents",    default: 0,     null: false
    t.string   "unit_price_currency", default: "EUR", null: false
  end

end
