class Document < ActiveRecord::Base
  groupify :group_member
  groupify :named_group_member
  belongs_to :transport_order
  mount_uploader :attachment, AttachmentUploader
  validates :name, presence: true
end
