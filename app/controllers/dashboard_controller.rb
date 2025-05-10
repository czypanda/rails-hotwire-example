class DashboardController < ApplicationController
  def index
    current_folder    = find_folder_from_path

    folders           = current_folder.subfolders
    file_entries      = current_folder.file_entries

    folders_presenters       = folders.map { |folder| ::FolderPresenter.new(folder: folder) }
    file_entries_presenters  = file_entries.map { |file_entry| ::FileEntryPresenter.new(file_entry: file_entry) }
    current_folder_presenter = ::FolderPresenter.new(folder: current_folder)

    respond_to do |format|
      format.html { render locals: {
        current_folder_presenter: current_folder_presenter,
        file_entries_presenters:  file_entries_presenters,
        folders_presenters:       folders_presenters,
        current_view:             current_view
      }}
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("dashboard_content",
            partial: "dashboard/dashboard_content",
            locals: {
              current_folder_presenter: current_folder_presenter,
              file_entries_presenters:  file_entries_presenters,
              folders_presenters:       folders_presenters,
              current_view:             current_view
            }
          ),
          turbo_stream.update("current_path",
            partial: "dashboard/path",
            locals: {
              current_folder_presenter: current_folder_presenter
            }
          ),
          turbo_stream.update("dashboard_controls",
            partial: "dashboard/controls",
            locals: {
              current_folder_id: current_folder_presenter.id
            }
          )
        ]
      end
    end
  end

  def update_view_preference
    session[:preferred_view] = params[:view]

    head :ok
  end

  private

  def find_folder_from_path
    root_folder = Folder.find_by(name: 'Root')

    return root_folder unless params[:path]

    path_segments = params[:path].split('/')
    current       = root_folder

    path_segments.each do |segment|
      current = current.subfolders.find_by(name: segment)

      break unless current
    end

    current || root_folder
  end
end
