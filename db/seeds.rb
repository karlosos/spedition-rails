# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

group = Group.first

mail_template_loading = MailTemplate.new
mial_template_loading.type = "loading"
mail_template_loading.subject = "Ladung von {0} ist bereits geladen worden."
mail_template_loading.content = "Sehr geehrte Damen und Herren,

Ihre Ladung von {0} wurde beladen. nach der Entladung werden wir Sie informieren.
Die aktuelle Position des LKW's koennen sie jederzeit Dank unserem GPS System  sehen unter:
https://business.tomtom.com/de_de/products/login/
Accountname: mtransport
Benutzername: {1}
Passwort: {1}


--
Mit freundlichen Grüßen / Best regards

Chris Sośnicki
Tel +48 888195113
Fax +48 68320690

.....................................................................

Mtransport
Zawiszy Czarnego 2B
65-387 Zielona Gora

E-Mail: info@mtransport.pl
Internet: www.mtransport.pl"

mail_template_loading.save
group.default_value.mail_templates << mail_template_loading

mail_template_unloading = MailTemplate.new
mail_template_unloading.type = "unloading"
mail_template_unloading.subject = "Ladung von {0} ist bereits zugestellt worden."
mail_template_unloading.content = "Guten Tag!

Wir informieren, Ihre Ladung von {0} wurde zugestellt.
Wir freuen uns auch zukunftig auf eine vertrauensvolle Zusammenarbeit.
Info über eventuelle Ladungen und Angebote von Ihnen bitte an info@mtransport.pl.

... mit uns fährt Ihre Sendung 1. Klasse!




https://business.tomtom.com/de_de/products/login/
Accountname: mtransport
Benutzername: {1}
Passwort: {1}


--
Mit freundlichen Grüßen / Best regards


Chris Sośnicki
Tel +48 888195113
Fax +48 683200690

.....................................................................

Mtransport
Zawiszy Czarnego 2B
65-387 Zielona Gora

E-Mail: info@mtransport.pl
Internet: www.mtransport.pl"

mail_template_unloading.save
group.default_value.mail_templates << mail_template_unloading

mail_template_documents = MailTemplate.new
mail_template_documents.type = "documents"
mail_template_documents.subject = "Ladung von {0} - Dokumente und Abmessungen des Wagens"
mail_template_documents.content = "Sehr geehrte Damen und Herren

Wir senden Ihnen unsere Firmendokumente , Versicherung und Briefkopf.

Kennzeichen:
{1}
LKW Abmessungen:
{2}

Den Auftrag senden Sie bitte per Mail oder fax unter die Nummer +48 683200690


Die aktuelle Position des LKW's koennen sie jederzeit Dank unserem GPS System  sehen unter:
https://business.tomtom.com/de_de/products/login/
Accountname: mtransport
Benutzername: {1}
Passwort: {1}


--
Mit freundlichen Grüßen / Best regards


Chris Sośnicki
Tel +48 888195113
Fax +48 683200690

.....................................................................

Mtransport
Zawiszy Czarnego 2B
65-387 Zielona Gora

E-Mail: info@mtransport.pl
Internet: www.mtransport.pl"

mail_template_documents.save
group.default_value.mail_templates << mail_template_documents

mail_template_vindication = MailTemplate.new
mail_template_vindication.type = "vindication"
mail_template_vindication.subject = "Mahnung 1 zu Rechnung Nummer {0}"
mail_template_vindication.content = "Sehr geehrte Dammen und Herren,

Unsere Rechnung {0} über den Betrag von €{1} Euro ist {2} Tage über dem Zahlungstermin und ist zur Zahlung fällig.
Wir bitten Sie darum, den kompletten Rechnungsbetrag unverzüglich auf unser unten genanntes Bankkonto zu überweisen.
Da wir bislang nichts von Ihnen gehört haben, hoffen wir, dass Sie mit unseren Leistungen zufrieden waren. Sollte es diesbezüglich etwaige Beanstandungen geben, dann lassen Sie uns dies bitte umgehend wissen.
Bei Rückfragen können Sie sich jederzeit gerne an uns wenden.

BANK NAME – ALIOR BANK
EURO – PL63 2490 0005 0000 4600 5759 7795
SWIFT – ALBPPLPW

Wurde diese Rechnung bereits bezahlt, dann teilen Sie uns bitte mit, wann es geschehen ist.
Wenn Sie diese Information nicht haben, geben Sie uns bitte die E-Mail-Adresse der Person, die für die Zahlungen zuständig ist.

Mit freundlichen Grüßen / Best regards

Artur Cichocki

.....................................................................

Mtransport Sp. z o.o., Sp. K.
Zawiszy Czarnego 2B
65-387 Zielona Gora

Tel.: 0048 - (0) 509309280
Fax:.0048 - (0) 68 3200690


E - mail: artur@mtransport.pl
Internet: www.mtransport.pl"

mail_template_vindication.save
group.default_value.mail_templates << mail_template_vindication

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
  group.add(t)
end

carriers_text = File.read(Rails.root.join('lib', 'seeds', 'carriers.csv'))
carriers_csv = CSV.parse(carriers_text, :headers => true, :encoding => 'ISO-8859-1')
carriers_csv.each_with_index do |row, i|
  carrier_client = Client.new
  carrier_client.build_address
  carrier_client.build_contact
  t = Carrier.new
  t.registration_number = row["registration_number"]
  t.size = row["size"]
  carrier_client.name = row["carrier_name"]
  t.driver_email = row["driver_email"]
  if !t.driver_email.present?
    t.driver_email = "driver_email@gmail.com"
  end
  carrier_email = Email.new
  carrier_email.address = row["carrier_email"]
  if !carrier_email.address.present?
    carrier_email.address = "carrier_email@example.com"
  end
  carrier_client.contact.emails << carrier_email
  t.driver_name = row["driver_name"]
  carrier_client.address.city = "x"
  carrier_client.address.street = "x"
  carrier_client.address.zip = "x"
  carrier_client.address.country = "PL"
  t.valid?
  carrier_client.save
  group.add(carrier_client)
  t.client = carrier_client
  t.save
  group.add(t)
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
admin.email = "admin@mtransport.pl"
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

group.add(admin, as: "admin")
group.add(speditor, as: "speditor")
group.add(accountant, as: "accountant ")
