class AddFolderIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :folder_id, :string
  end
end
