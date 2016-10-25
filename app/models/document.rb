class Document < ActiveRecord::Base
  groupify :group_member
  groupify :named_group_member
  belongs_to :transport_order
end
