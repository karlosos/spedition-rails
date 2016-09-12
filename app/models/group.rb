class Group < ActiveRecord::Base
  groupify :group, members: [:users], default_members: :users
  has_one :default_value
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
