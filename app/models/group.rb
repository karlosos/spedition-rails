class Group < ActiveRecord::Base
  groupify :group, members: [:users], default_members: :users

  ROLES = [
    'admin',
    'spedition',
    'accounting'
  ].freeze
end
