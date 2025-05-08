class CreateFileEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :file_entries do |t|
      t.string :name, null: false
      t.text :description
      t.string :tags, array: true, default: []
      t.string :file_data, null: false # Path or identifier for the file
      t.integer :size
      t.string :content_type
      t.references :folder, foreign_key: true
      t.timestamps
    end
  end
end 