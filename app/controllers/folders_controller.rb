class FoldersController < ApplicationController
  def new
    current_folder = Folder.find(params[:current_folder_id])
    folder         = Folder.new(parent: current_folder)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "new_folder_dialog",
            partial: "folders/new_form_dialog",
            locals: {
              folder: folder
            }
          )
        ]
      end
    end
  end

  def edit
    folder = Folder.find(params[:id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "edit_folder_dialog",
            partial: "folders/edit_form_dialog",
            locals: {
              folder: folder
            }
          )
        ]
      end
    end
  end

  def create
    new_folder        = Folder.new(folder_params)
    create_successful = new_folder.save

    if create_successful
      current_folder = new_folder.parent

      folders = current_folder.subfolders
      files   = current_folder.file_entries

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Folder created successfully"

          render turbo_stream: [
            turbo_stream.update(
              "dashboard_content",
              partial: "dashboard/dashboard_content",
              locals: {
                folders:           folders,
                files:             files,
                current_folder:    current_folder,
                current_view:      current_view
              }),
            turbo_stream.update("new_folder_dialog"),
            render_turbo_stream_flash_messages
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Failed to create folder"

          render turbo_stream: [
            turbo_stream.replace("new_folder_form",
              partial: "folders/new_form",
              locals: {
                folder: new_folder
              }
            ),
            render_turbo_stream_flash_messages
          ]
        end
      end
    end
  end

  def update
    folder            = Folder.find(params[:id])
    update_successful = folder.update(folder_params)

    if update_successful
      current_folder = folder.parent

      folders = current_folder.subfolders
      files   = current_folder.file_entries

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Folder updated successfully"

          render turbo_stream: [
            turbo_stream.update(
              "dashboard_content",
              partial: "dashboard/dashboard_content",
              locals: {
                folders:           folders,
                files:             files,
                current_folder:    current_folder,
                folder:            folder,
                current_view:      current_view
              }),
            turbo_stream.update("edit_folder_dialog"),
            render_turbo_stream_flash_messages
          ]
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Failed to update folder"

          render turbo_stream: [
            turbo_stream.update("edit_folder_form",
              partial: "folders/edit_form",
              locals: {
                folder: folder
              }
            ),
            render_turbo_stream_flash_messages
          ]
        end
      end
    end
  end

  def delete
    folder = Folder.find(params[:id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "delete_folder_dialog",
            partial: "folders/delete_form_dialog",
            locals: {
              folder: folder
            }
          )
        ]
      end
    end
  end

  def destroy
    folder = Folder.find(params[:id])

    current_folder = folder.parent

    # delete of all child files and folders is not implemented
    folder.destroy!

    folders = current_folder.subfolders
    files   = current_folder.file_entries

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Folder deleted successfully"

        render turbo_stream: [
          turbo_stream.update(
            "dashboard_content",
            partial: "dashboard/dashboard_content",
            locals: {
              folders:           folders,
              files:             files,
              current_folder:    current_folder,
              current_view:      current_view
            }),
          turbo_stream.update("delete_folder_dialog"),
          render_turbo_stream_flash_messages
        ]
      end
    end
  end

  def move
    folder = Folder.find(move_folder_params[:current_folder_id])

    current_folder = folder.parent

    folder.update(parent_id: move_folder_params[:target_folder_id])

    folders = current_folder.subfolders
    files   = current_folder.file_entries

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Folder moved successfully"

        render turbo_stream: [
          turbo_stream.update(
            "dashboard_content",
            partial: "dashboard/dashboard_content",
            locals: {
              folders:           folders,
              files:             files,
              current_folder:    current_folder,
              current_view:      current_view
            }
          ),
          render_turbo_stream_flash_messages
        ]
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
