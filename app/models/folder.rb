class Folder < ApplicationRecord
  belongs_to :parent, class_name: 'Folder', optional: true
  has_many :subfolders, class_name: 'Folder', foreign_key: 'parent_id', dependent: :destroy
  has_many :file_entries, dependent: :destroy

  validates :name, presence: true

  def ancestors
    return [] unless parent
    [parent] + parent.ancestors
  end
end 