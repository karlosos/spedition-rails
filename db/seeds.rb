# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'clients.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  t = Client.new
  t.build_address
  t.build_contact
  t.name = row['name']
  t.address.line1 = row['line1']
  t.address.zip = row['zip']
  t.address.state = row['state']
  t.address.city = row['city']
  t.address.country = row['country']
  t.regon = row['regon']
  t.pesel = row['pesel']
  t.nip = row['nip']
  t.invoice_currency = row['invoice_currency']
  t.freight_currency = row['freight_currency']
  t.payment_term = row['payment_term']
  t.contact.phone1 = row['phone1']
  t.contact.phone2 = row['phone2']
  t.contact.fax = row['fax']
  t.contact.email = row['email']
  t.contact.www = row['www']
  t.invoice_language = row['invoice_language']
  t.save
  puts "#{t.name} saved"
end

puts "There are now #{Client.count} rows in the transactions table"
