class FileEntriesController < ApplicationController
  def new
    current_folder = Folder.find(params[:current_folder_id])
    file_entry     = FileEntry.new(folder: current_folder)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "new_file_entry_dialog",
            partial: "file_entries/new_form_dialog",
            locals: {
              file_entry: file_entry
            }
          )
        ]
      end
    end
  end

  def edit
    file_entry = FileEntry.find(params[:id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "edit_file_entry_dialog",
            partial: "file_entries/edit_form_dialog",
            locals: {
              file_entry: file_entry
            }
          )
        ]
      end
    end
  end

  def create
    file_entry        = FileEntry.new(file_entry_params)
    create_successful = file_entry.save

    if create_successful
      current_folder = file_entry.folder

      folders = current_folder.subfolders
      files   = current_folder.file_entries

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "File created successfully"

          render turbo_stream: [
            turbo_stream.update("dashboard_content",
              partial: "dashboard/dashboard_content",
              locals: {
                folders:        folders,
                files:          files,
                current_folder: current_folder,
                current_view:   current_view
              }
            ),
            turbo_stream.update("new_file_entry_dialog"),
            render_turbo_stream_flash_messages
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Failed to create file"

          render turbo_stream: [
            turbo_stream.replace("new_file_form",
              partial: "file_entries/new_form",
              locals: {
                file_entry:        file_entry
              }
            ),
            render_turbo_stream_flash_messages
          ]
        end
      end
    end
  end

  def edit
    file_entry = FileEntry.find(params[:id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "edit_file_entry_dialog",
            partial: "file_entries/edit_form_dialog",
            locals: {
              file_entry: file_entry
            }
          )
        ]
      end
    end
  end

  def update
    file_entry = FileEntry.find(params[:id])

    update_successful = file_entry.update(file_entry_params)

    if update_successful
      current_folder = file_entry.folder

      folders = current_folder.subfolders
      files   = current_folder.file_entries

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "File updated successfully"

          render turbo_stream: [
            turbo_stream.update("dashboard_content",
              partial: "dashboard/dashboard_content",
              locals: {
                folders:        folders,
                files:          files,
                current_folder: current_folder,
                current_view:   current_view
              }
            ),
            turbo_stream.update("edit_file_entry_dialog"),
            render_turbo_stream_flash_messages
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Failed to update file"

          render turbo_stream: [
            turbo_stream.update("edit_file_form",
              partial: "file_entries/edit_form",
              locals: {
                file_entry: file_entry
              }
            ),
            render_turbo_stream_flash_messages
          ]
        end
      end
    end
  end

  def delete
    file_entry = FileEntry.find(params[:id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "delete_file_entry_dialog",
            partial: "file_entries/delete_form_dialog",
            locals: {
              file_entry: file_entry
            }
          )
        ]
      end
    end
  end

  def destroy
    file_entry = FileEntry.find(params[:id])
    file_entry.destroy!

    current_folder = file_entry.folder

    folders = current_folder.subfolders
    files   = current_folder.file_entries

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "File deleted successfully"

        render turbo_stream: [
          turbo_stream.update("dashboard_content",
            partial: "dashboard/dashboard_content",
            locals: {
              folders:        folders,
              files:          files,
              current_folder: current_folder,
              current_view:   current_view
            }
          ),
          turbo_stream.update("delete_file_entry_dialog"),
          render_turbo_stream_flash_messages
        ]
      end
    end
  end

  def move
    file_entry = FileEntry.find(move_file_entry_params[:current_file_id])

    current_folder = file_entry.folder

    file_entry.update(folder_id: move_file_entry_params[:target_file_id])

    folders = current_folder.subfolders
    files   = current_folder.file_entries

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "File moved successfully"

        render turbo_stream: [
          turbo_stream.update("dashboard_content",
            partial: "dashboard/dashboard_content",
            locals: {
              folders:        folders,
              files:          files,
              current_folder: current_folder,
              current_view:   current_view
            }
          ),
          render_turbo_stream_flash_messages
        ]
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
