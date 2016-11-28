class MailTemplate < ActiveRecord::Base
  belongs_to :default_value

  TYPES = [
    'loading',
    'unloading',
    'documents',
    'vindication_1',
    'vindication_2',
    'vindication_3'
  ].freeze
end
