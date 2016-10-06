class Group < ActiveRecord::Base
  groupify :group, members: [:users, :clients, :invoices, :invoice_names, :items, :carriers, :transport_orders, :transport_order_name, :carrier_memberships], default_members: :users
  has_one :default_value
  validates_uniqueness_of :subdomain
  ROLES = [
    'admin',
    'spedition',
    'accounting',
    'debt_collector'
  ].freeze

  after_create :create_default_values

  private
  def create_default_values
    default_value = DefaultValue.new
    default_value.group = self
    mail_template = MailTemplate.new
    mail_template.subject = "Domyślny mail"
    mail_template.content = "Domyślna treść maila"
    mail_template.save
    default_value.mail_templates << mail_template
    default_value.save
  end
end
