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

ActiveRecord::Schema.define(version: 20160828161644) do

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

  create_table "carriers", force: true do |t|
    t.string   "registration_number"
    t.string   "size"
    t.string   "carrier_name"
    t.string   "carrier_email"
    t.string   "driver_name"
    t.string   "driver_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nip"
    t.boolean  "is_third_party"
  end

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

  create_table "emails", force: true do |t|
    t.string   "address"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "emails", ["contact_id"], name: "index_emails_on_contact_id"

  create_table "freichtage_descriptions", force: true do |t|
    t.decimal  "weight"
    t.decimal  "value"
    t.decimal  "length"
    t.decimal  "width"
    t.decimal  "height"
    t.decimal  "packages"
    t.string   "packages_type"
    t.integer  "transport_order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "freichtage_descriptions", ["transport_order_id"], name: "index_freichtage_descriptions_on_transport_order_id"

  create_table "invoice_item_corrections", force: true do |t|
    t.integer  "invoice_id"
    t.integer  "item_id"
    t.string   "item_name"
    t.string   "item_name_correction"
    t.integer  "quantity",                                default: 1
    t.integer  "quantity_correction",                     default: 1
    t.integer  "quantity_difference",                     default: 1
    t.integer  "tax_rate",                                default: 23
    t.integer  "tax_rate_correction",                     default: 23
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit_price_cents",                        default: 0,     null: false
    t.string   "unit_price_currency",                     default: "EUR", null: false
    t.integer  "unit_price_correction_cents",             default: 0,     null: false
    t.string   "unit_price_correction_currency",          default: "EUR", null: false
    t.integer  "unit_price_difference_cents",             default: 0,     null: false
    t.string   "unit_price_difference_currency",          default: "EUR", null: false
    t.integer  "value_added_tax_cents",                   default: 0,     null: false
    t.string   "value_added_tax_currency",                default: "EUR", null: false
    t.integer  "value_added_tax_correction_cents",        default: 0,     null: false
    t.string   "value_added_tax_correction_currency",     default: "EUR", null: false
    t.integer  "value_added_tax_difference_cents",        default: 0,     null: false
    t.string   "value_added_tax_difference_currency",     default: "EUR", null: false
    t.integer  "net_price_cents",                         default: 0,     null: false
    t.string   "net_price_currency",                      default: "EUR", null: false
    t.integer  "net_price_correction_cents",              default: 0,     null: false
    t.string   "net_price_correction_currency",           default: "EUR", null: false
    t.integer  "net_price_difference_cents",              default: 0,     null: false
    t.string   "net_price_difference_currency",           default: "EUR", null: false
    t.integer  "total_selling_price_cents",               default: 0,     null: false
    t.string   "total_selling_price_currency",            default: "EUR", null: false
    t.integer  "total_selling_price_correction_cents",    default: 0,     null: false
    t.string   "total_selling_price_correction_currency", default: "EUR", null: false
    t.integer  "total_selling_price_difference_cents",    default: 0,     null: false
    t.string   "total_selling_price_difference_currency", default: "EUR", null: false
  end

  add_index "invoice_item_corrections", ["invoice_id"], name: "index_invoice_item_corrections_on_invoice_id"
  add_index "invoice_item_corrections", ["item_id"], name: "index_invoice_item_corrections_on_item_id"

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
    t.string   "prefix"
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
    t.integer  "status",                       default: 1
    t.string   "total_price_in_words"
    t.integer  "deadline",                     default: 50
    t.datetime "date_deadline"
    t.string   "invoice_currency",             default: "EUR"
    t.string   "invoice_exchange_currency",    default: "PLN"
    t.string   "invoice_language",             default: "PL"
    t.string   "client_nip"
    t.string   "kind"
    t.integer  "invoice_to_correct_id"
    t.text     "correction_cause"
    t.datetime "currency_rate_date"
  end

  add_index "invoices", ["kind"], name: "index_invoices_on_kind"

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

  create_table "loading_places", force: true do |t|
    t.integer  "transport_order_id"
    t.string   "city"
    t.string   "zip"
    t.string   "country"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "loading_places", ["transport_order_id"], name: "index_loading_places_on_transport_order_id"

  create_table "transport_order_names", force: true do |t|
    t.integer  "number"
    t.integer  "year"
    t.integer  "transport_order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transport_order_names", ["transport_order_id"], name: "index_transport_order_names_on_transport_order_id"

  create_table "transport_orders", force: true do |t|
    t.integer  "client_id"
    t.integer  "carrier_id"
    t.string   "route"
    t.decimal  "distance"
    t.string   "loading_country"
    t.datetime "unloading_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "freight_rate_cents",             default: 0,     null: false
    t.string   "freight_rate_currency",          default: "EUR", null: false
    t.integer  "seller_id"
    t.integer  "profit_margin_cents",            default: 0,     null: false
    t.string   "profit_margin_currency",         default: "EUR", null: false
    t.text     "client_street"
    t.string   "client_name"
    t.string   "client_zip"
    t.string   "client_city"
    t.string   "client_country"
    t.string   "client_email"
    t.string   "client_phone"
    t.string   "carrier_name"
    t.string   "carrier_driver_name"
    t.string   "carrier_street"
    t.string   "carrier_country"
    t.string   "carrier_city"
    t.string   "carrier_zip"
    t.boolean  "loading_status",                 default: false
    t.boolean  "unloading_status",               default: false
    t.boolean  "driver_documents_status",        default: false
    t.string   "client_nip"
    t.string   "carrier_nip"
    t.string   "speditor_name"
    t.string   "speditor_email"
    t.text     "vehicle_requirements"
    t.text     "payment_type"
    t.text     "additional_comments"
    t.text     "arrangements"
    t.string   "cmr_numer"
    t.string   "reference_transport_order_name"
    t.string   "car_registration_number"
  end

  create_table "unloading_places", force: true do |t|
    t.integer  "transport_order_id"
    t.string   "city"
    t.string   "zip"
    t.string   "country"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "unloading_places", ["transport_order_id"], name: "index_unloading_places_on_transport_order_id"

end
