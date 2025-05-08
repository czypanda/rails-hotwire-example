class FileEntry < ApplicationRecord
  has_one_attached :file_data
  
  belongs_to :folder, optional: true

  validates :name, presence: true
  validates :file_data, presence: true

  # For simplicity, file_data can be a string path or binary, depending on storage approach
end
