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

ActiveRecord::Schema.define(version: 20160705180344) do

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
    t.text     "street"
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
    t.integer  "invoice_id"
    t.integer  "item_id"
    t.integer  "quantity",                     default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit_price_cents",             default: 0,     null: false
    t.string   "unit_price_currency",          default: "EUR", null: false
    t.integer  "tax_rate",                     default: 23
    t.integer  "value_added_tax_cents",        default: 0,     null: false
    t.string   "value_added_tax_currency",     default: "EUR", null: false
    t.integer  "net_price_cents",              default: 0,     null: false
    t.string   "net_price_currency",           default: "EUR", null: false
    t.integer  "total_selling_price_cents",    default: 0,     null: false
    t.string   "total_selling_price_currency", default: "EUR", null: false
  end

  add_index "invoice_items", ["invoice_id"], name: "index_invoice_items_on_invoice_id"
  add_index "invoice_items", ["item_id"], name: "index_invoice_items_on_item_id"

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
    t.integer  "value_added_tax_cents",        default: 0,     null: false
    t.string   "value_added_tax_currency",     default: "EUR", null: false
    t.integer  "net_price_cents",              default: 0,     null: false
    t.string   "net_price_currency",           default: "EUR", null: false
    t.integer  "total_selling_price_cents",    default: 0,     null: false
    t.string   "total_selling_price_currency", default: "EUR", null: false
    t.text     "client_street"
    t.string   "client_name"
    t.string   "client_zip"
    t.string   "client_city"
    t.string   "client_country"
    t.string   "client_email"
    t.string   "client_phone"
    t.string   "place"
    t.string   "currency_rate_table_name"
    t.string   "currency_rate_name"
    t.decimal  "currency_rate"
    t.integer  "status"
  end

  create_table "items", force: true do |t|
    t.string   "name"
    t.string   "pkwiu"
    t.string   "unit"
    t.integer  "tax"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit_price_cents",    default: 0,     null: false
    t.string   "unit_price_currency", default: "EUR", null: false
  end

end
