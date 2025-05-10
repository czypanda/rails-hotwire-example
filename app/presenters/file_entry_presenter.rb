class FileEntryPresenter
    include ActionView::Helpers::NumberHelper

    def initialize(file_entry:)
      @file_entry = file_entry
    end

    def id
        @file_entry.id
    end

    def name
        @file_entry.name
    end

    def date_modified
        @file_entry.updated_at.strftime('%m/%d/%Y')
    end

    def size
        number_to_human_size(@file_entry.size).presence || '-'
    end

    def tags
        @file_entry.tags.join(', ').presence || '-'
    end

    def parent_name
        @file_entry.parent.name
    end

    def parent_present?
        @file_entry.parent.present?
    end

    def parent_blank?
        @file_entry.parent.blank?
    end

    def to_model
        @file_entry.to_model
    end

    def errors
        @file_entry.errors
    end

    def folder_id
        @file_entry.folder_id
    end
end
