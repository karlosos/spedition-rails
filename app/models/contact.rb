class Contact < ActiveRecord::Base
  belongs_to :contactable, polymorphic: true
  has_many :emails, inverse_of: :contact

  accepts_nested_attributes_for :emails
end
