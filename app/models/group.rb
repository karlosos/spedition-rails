class Group < ActiveRecord::Base
  groupify :group, members: [:users, :clients, :invoices, :invoice_names, :items, :carriers], default_members: :users
  has_one :default_value
  validates_uniqueness_of :subdomain
  ROLES = [
    'admin',
    'spedition',
    'accounting'
  ].freeze

  after_create :create_default_values

  private
  def create_default_values
    default_value = DefaultValue.new
    default_value.group = self
    default_value.save
  end
end
