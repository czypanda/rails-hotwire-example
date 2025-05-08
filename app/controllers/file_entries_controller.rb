class FileEntriesController < ApplicationController
  def create
    available_folders = Folder.all

    file_entry        = FileEntry.new(file_entry_params)
    create_successful = file_entry.save

    if create_successful
      current_folder = file_entry.folder

      dashboard_folders = current_folder.subfolders
      dashboard_files   = current_folder.file_entries

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "File created successfully"

          render locals: {
            dashboard_folders: dashboard_folders,
            dashboard_files:   dashboard_files,
            current_folder:    current_folder,
            available_folders: available_folders,
            file_entry:        file_entry,
            current_view:      current_view
          }
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Failed to create file"

          render turbo_stream: [
            turbo_stream.replace('new_file_form',
              partial: 'file_entries/new_form',
              locals: {
                file_entry:        file_entry,
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

    file_entry = FileEntry.find(params[:id])

    source_id         = params[:source_id]
    update_successful = file_entry.update(file_entry_params)

    if update_successful
      current_folder = file_entry.folder

      dashboard_folders = current_folder.subfolders
      dashboard_files   = current_folder.file_entries

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "File updated successfully"

          render locals: {
            dashboard_folders: dashboard_folders,
            dashboard_files:   dashboard_files,
            current_folder:    current_folder,
            available_folders: available_folders,
            file_entry:        file_entry,
            current_view:      current_view
          }
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Failed to update file"

          render turbo_stream: [
            turbo_stream.update("edit_file_form_#{file_entry.id}_#{source_id}",
              partial: 'file_entries/edit_form',
              locals: {
                file_entry:        file_entry,
                available_folders: available_folders,
                source_id:         source_id,
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

    file_entry = FileEntry.find(params[:id])
    file_entry.destroy!
    
    current_folder = file_entry.folder

    dashboard_folders = current_folder.subfolders
    dashboard_files   = current_folder.file_entries

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "File deleted successfully"

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

  def move
    available_folders = Folder.all

    file_entry = FileEntry.find(move_file_entry_params[:current_file_id])

    current_folder = file_entry.folder

    file_entry.update(folder_id: move_file_entry_params[:target_file_id])

    dashboard_folders = current_folder.subfolders
    dashboard_files   = current_folder.file_entries

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "File moved successfully"

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

  def file_entry_params
    params.require(:file_entry).permit(:name, :description, :file_data, :size, :content_type, :folder_id, :tags)
  end

  def move_file_entry_params
    params.permit(:target_file_id, :current_file_id)
  end
end 