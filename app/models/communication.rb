class Communication < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :user

  validates_presence_of :invoice
end
