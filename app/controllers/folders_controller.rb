class FoldersController < ApplicationController
  def create
    available_folders = Folder.all

    new_folder        = Folder.new(folder_params)
    create_successful = new_folder.save

    if create_successful
      current_folder = new_folder.parent

      dashboard_folders = current_folder.subfolders
      dashboard_files   = current_folder.file_entries

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Folder created successfully"

          render locals: {
            dashboard_folders: dashboard_folders,
            dashboard_files: dashboard_files,
            current_folder: current_folder,
            available_folders: available_folders,
            current_view: current_view
          }
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Failed to create folder"

          render turbo_stream: [
            turbo_stream.replace('new_folder_form',
              partial: 'folders/new_form',
              locals: {
                folder: new_folder,
                available_folders: available_folders,
              }
            ),
            render_turbo_stream_flash_messages
          ]
        end
      end
    end
  end

  def update
    available_folders = Folder.all

    folder            = Folder.find(params[:id])
    source_id         = params[:source_id]
    update_successful = folder.update(folder_params)

    if update_successful
      current_folder = folder.parent

      dashboard_folders = current_folder.subfolders
      dashboard_files   = current_folder.file_entries

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Folder updated successfully"

          render locals: {
            dashboard_folders: dashboard_folders,
            dashboard_files:   dashboard_files,
            current_folder:    current_folder,
            available_folders: available_folders,
            folder:            folder,
            current_view:      current_view
          }
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Failed to update folder"

          render turbo_stream: [
            turbo_stream.update("edit_folder_form_#{folder.id}_#{source_id}",
              partial: 'folders/edit_form',
              locals: { 
                folder:            folder, 
                available_folders: available_folders,
                source_id:         source_id
              }
            ),
            render_turbo_stream_flash_messages
          ]
        end
      end
    end
  end

  def destroy
    available_folders = Folder.all

    folder = Folder.find(params[:id])

    current_folder = folder.parent

    folder.destroy!

    dashboard_folders = current_folder.subfolders
    dashboard_files = current_folder.file_entries

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Folder deleted successfully"

        render locals: {
          dashboard_folders: dashboard_folders,
          dashboard_files: dashboard_files,
          current_folder: current_folder,
          available_folders: available_folders,
          current_view: current_view
        }
      end
    end
  end

  def move
    available_folders = Folder.all

    folder = Folder.find(move_folder_params[:current_folder_id])

    current_folder = folder.parent

    folder.update(parent_id: move_folder_params[:target_folder_id])

    dashboard_folders = current_folder.subfolders
    dashboard_files   = current_folder.file_entries

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Folder moved successfully"

        render locals: {
          dashboard_folders: dashboard_folders,
          dashboard_files:   dashboard_files,
          current_folder:    current_folder,
          available_folders: available_folders,
          current_view:      current_view
        }
      end
    end
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :parent_id)
  end

  def move_folder_params
    params.permit(:target_folder_id, :current_folder_id)
  end
end 