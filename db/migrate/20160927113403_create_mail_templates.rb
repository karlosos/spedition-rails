class CreateMailTemplates < ActiveRecord::Migration
  def change
    create_table :mail_templates do |t|
      t.text :subject
      t.text :content
      t.references :default_value, index: true
      t.timestamps
    end
  end
end
