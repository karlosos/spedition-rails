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
csv.each_with_index do |row, i|
  break if i == 50
  t = Client.new
  t.build_address
  t.build_contact
  t.name = row['name']
  t.address.street = row['line1']
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
  email = Email.new
  email.address = row['email']
  t.contact.emails << email
  t.contact.www = row['www']
  t.invoice_language = row['invoice_language']
  t.save
end

carriers_text = File.read(Rails.root.join('lib', 'seeds', 'carriers.csv'))
carriers_csv = CSV.parse(carriers_text, :headers => true, :encoding => 'ISO-8859-1')
carriers_csv.each_with_index do |row, i|
  t = Carrier.new
  t.build_address
  t.build_contact
  t.registration_number = row["registration_number"]
  t.size = row["size"]
  t.carrier_name = row["carrier_name"]
  t.driver_email = row["driver_email"]
  if !t.driver_email.present?
    t.driver_email = "driver_email@gmail.com"
  end
  carrier_email = Email.new
  carrier_email.address = row["carrier_email"]
  if !carrier_email.address.present?
    carrier_email.address = "carrier_email@example.com"
  end
  t.contact.emails << carrier_email
  t.driver_name = row["driver_name"]
  t.address.city = "x"
  t.address.street = "x"
  t.address.zip = "x"
  t.address.country = "PL"
  t.valid?
  t.save
end

puts "There are now #{Carrier.count} rows in the carriers table"

TAX_TYPES = [*0..100, "zw", "nw"].freeze

[*0..100].each do |tax|
  t = TaxRate.new
  t.value = tax
  t.name = tax.to_s
  t.save
end

["zw", "nw"].each do |tax|
  t = TaxRate.new
  t.value = 0
  t.name = tax
  t.save
end

admin = User.new()
admin.email = "artur@mtransport.pl"
admin.password = '123456'
admin.encrypted_password = User.new.send(:password_digest, '123456')
admin.save

speditor = User.new()
speditor.email = "speditor@mtransport.pl"
speditor.password = '123456'
speditor.encrypted_password = User.new.send(:password_digest, '123456')
speditor.save

accountant = User.new()
accountant.email = "accountant@mtransport.pl"
accountant.password = '123456'
accountant.encrypted_password = User.new.send(:password_digest, '123456')
accountant.save

group = Group.new()
group.subdomain = "mtransport"
group.name = "MTransport"
group.save

group.add(admin, as: "admin")
group.add(speditor, as: "speditor")
group.add(accountant, as: "accountant ")
