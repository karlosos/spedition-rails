class DefaultValue < ActiveRecord::Base
  belongs_to :group
  has_many :mail_templates

  accepts_nested_attributes_for :mail_templates, allow_destroy: true
end
