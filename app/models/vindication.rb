class Vindication < ActiveRecord::Base
  belongs_to :invoice
  has_many :communications

  validates_presence_of :invoice
  validates_uniqueness_of :invoice
end
