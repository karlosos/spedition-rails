class Communication < ActiveRecord::Base
  belongs_to :vindication
  belongs_to :user

  validates_presence_of :vindication
end
