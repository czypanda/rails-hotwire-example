class DashboardController < ApplicationController
  def index
    current_folder    = find_folder_from_path
    folders           = current_folder.subfolders
    files             = current_folder.file_entries

    respond_to do |format|
      format.html { render locals: {
        current_folder:    current_folder,
        files:             files,
        folders:           folders,
        current_view:      current_view
      }}
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("dashboard_content",
            partial: "dashboard/dashboard_content",
            locals: {
              current_folder:    current_folder,
              files:             files,
              folders:           folders,
              current_view:      current_view
            }
          ),
          turbo_stream.update("current_path",
            partial: "dashboard/path",
            locals: {
              current_folder: current_folder
            }
          ),
          turbo_stream.update("dashboard_controls",
            partial: "dashboard/controls",
            locals: {
              current_folder_id: current_folder.id
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
