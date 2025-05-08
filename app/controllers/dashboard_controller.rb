class DashboardController < ApplicationController
  def index
    current_folder    = find_folder_from_path
    dashboard_folders = current_folder.subfolders
    dashboard_files   = current_folder.file_entries
    available_folders = Folder.all

    respond_to do |format|
      format.html { render locals: { 
        current_folder:    current_folder,
        dashboard_folders: dashboard_folders,
        dashboard_files:   dashboard_files,
        available_folders: available_folders,
        current_view:      current_view
      }}
      format.turbo_stream { render locals: {
        current_folder:    current_folder,
        dashboard_folders: dashboard_folders,
        dashboard_files:   dashboard_files,
        available_folders: available_folders,
        current_view:      current_view
      }}
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
