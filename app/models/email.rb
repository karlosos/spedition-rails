class Email < ActiveRecord::Base
  belongs_to :contact
  validates :address, presence: true
end
