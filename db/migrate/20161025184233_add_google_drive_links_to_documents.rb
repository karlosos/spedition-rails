class AddGoogleDriveLinksToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :file_id, :string
    add_column :documents, :web_content_link, :string
  end
end
