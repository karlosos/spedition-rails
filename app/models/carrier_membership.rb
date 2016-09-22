class CarrierMembership < ActiveRecord::Base
  groupify :group_member
  groupify :named_group_member
  belongs_to :user
  belongs_to :carrier

  validates :user, presence: true
  validates :carrier, presence: true

  validates_uniqueness_of :carrier_id, :scope => :user_id
end
