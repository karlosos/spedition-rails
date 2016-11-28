class AddEmailTypeToMailTemplates < ActiveRecord::Migration
  def change
    add_column :mail_templates, :email_type, :string
  end
end
