class FolderPresenter
    def initialize(folder:)
        @folder = folder
    end

    def id
        @folder.id
    end

    def name
        @folder.name
    end

    def date_modified
        @folder.updated_at.strftime('%m/%d/%Y')
    end

    def parent_presenter
        @parent_presenter ||= @folder.parent.present? ? FolderPresenter.new(folder: @folder.parent) : nil
    end

    def parent_name
        parent_presenter.name
    end

    def parent_present?
        parent_presenter.present?
    end

    def parent_blank?
        parent_presenter.blank?
    end

    def is_root_folder?
        parent_presenter.blank?
    end

    def is_parent_root_folder?
        parent_presenter.is_root_folder?
    end

    def ancestors_reverse
       @folder.ancestors.reverse.map { |ancestor| FolderPresenter.new(folder: ancestor) }
    end

    def tags
        "-"
    end

    def size
       "-"
    end

    def to_model
        @folder.to_model
    end

    def errors
        @folder.errors
    end

    def parent_id
        @folder.parent_id
    end
end
