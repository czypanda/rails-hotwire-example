module DashboardHelper
  def dashboard_path_for(file_or_folder_presenter)
    return "/" if file_or_folder_presenter.parent_blank?

    if (file_or_folder_presenter.is_parent_root_folder?)
      "/" + file_or_folder_presenter.name
    else
      dashboard_path_for(file_or_folder_presenter.parent_presenter) + "/" + file_or_folder_presenter.name
    end
  end

  def show_empty_data_placeholder?(folders:, file_entries:, current_folder:)
    folders.empty? && file_entries.empty? && current_folder.is_root_folder?
  end
end
