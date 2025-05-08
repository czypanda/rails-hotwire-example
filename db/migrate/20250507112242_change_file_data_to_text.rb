class ChangeFileDataToText < ActiveRecord::Migration[8.0]
  def change
    change_column :file_entries, :file_data, :text
  end
end
