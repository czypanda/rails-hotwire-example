module DashboardHelper
  def dashboard_path_for(file_or_folder)
    return "/" if file_or_folder.parent.blank?

    if (file_or_folder.parent.name == "Root")
      "/" + file_or_folder.name
    else
      dashboard_path_for(file_or_folder.parent) + "/" + file_or_folder.name
    end
  end

  def is_root_folder?(dashboard_folder)
    dashboard_folder.parent.blank?
  end
end
