class FoldersController < ApplicationController
  def new
    current_folder = Folder.find(params[:current_folder_id])
    folder         = Folder.new(parent: current_folder)

    folder_presenter = FolderPresenter.new(folder: folder)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "new_folder_dialog",
            partial: "folders/new_form_dialog",
            locals: {
              folder_presenter: folder_presenter
            }
          )
        ]
      end
    end
  end

  def edit
    folder = Folder.find(params[:id])

    folder_presenter = FolderPresenter.new(folder: folder)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "edit_folder_dialog",
            partial: "folders/edit_form_dialog",
            locals: {
              folder_presenter: folder_presenter
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

      current_folder_presenter = FolderPresenter.new(folder: current_folder)
      file_entries_presenters  = files.map { |file| FileEntryPresenter.new(file_entry: file) }
      folders_presenters       = folders.map { |folder| FolderPresenter.new(folder: folder) }

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Folder created successfully"

          render turbo_stream: [
            turbo_stream.update(
              "dashboard_content",
              partial: "dashboard/dashboard_content",
              locals: {
                folders_presenters:       folders_presenters,
                file_entries_presenters:  file_entries_presenters,
                current_folder_presenter: current_folder_presenter,
                current_view:             current_view
              }),
            turbo_stream.update("new_folder_dialog"),
            render_turbo_stream_flash_messages
          ]
        end
      end
    else
      folder_presenter = FolderPresenter.new(folder: new_folder)

      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Failed to create folder"

          render turbo_stream: [
            turbo_stream.replace("new_folder_form",
              partial: "folders/new_form",
              locals: {
                folder_presenter: folder_presenter
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

      current_folder_presenter = FolderPresenter.new(folder: current_folder)
      file_entries_presenters  = files.map { |file| FileEntryPresenter.new(file_entry: file) }
      folders_presenters       = folders.map { |folder| FolderPresenter.new(folder: folder) }

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Folder updated successfully"

          render turbo_stream: [
            turbo_stream.update(
              "dashboard_content",
              partial: "dashboard/dashboard_content",
              locals: {
                folders_presenters:       folders_presenters,
                file_entries_presenters:  file_entries_presenters,
                current_folder_presenter: current_folder_presenter,
                current_view:             current_view
              }),
            turbo_stream.update("edit_folder_dialog"),
            render_turbo_stream_flash_messages
          ]
        end
      end
    else
      folder_presenter = FolderPresenter.new(folder: folder)

      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Failed to update folder"

          render turbo_stream: [
            turbo_stream.update("edit_folder_form",
              partial: "folders/edit_form",
              locals: {
                folder_presenter: folder_presenter
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

    folder_presenter = FolderPresenter.new(folder: folder)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "delete_folder_dialog",
            partial: "folders/delete_form_dialog",
            locals: {
              folder_presenter: folder_presenter
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

    current_folder_presenter = FolderPresenter.new(folder: current_folder)
    file_entries_presenters  = files.map { |file| FileEntryPresenter.new(file_entry: file) }
    folders_presenters       = folders.map { |folder| FolderPresenter.new(folder: folder) }

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Folder deleted successfully"

        render turbo_stream: [
          turbo_stream.update(
            "dashboard_content",
            partial: "dashboard/dashboard_content",
            locals: {
              folders_presenters:       folders_presenters,
              file_entries_presenters:  file_entries_presenters,
              current_folder_presenter: current_folder_presenter,
              current_view:             current_view
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

    current_folder_presenter = FolderPresenter.new(folder: current_folder)
    file_entries_presenters  = files.map { |file| FileEntryPresenter.new(file_entry: file) }
    folders_presenters       = folders.map { |folder| FolderPresenter.new(folder: folder) }

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Folder moved successfully"

        render turbo_stream: [
          turbo_stream.update(
            "dashboard_content",
            partial: "dashboard/dashboard_content",
            locals: {
              folders_presenters:       folders_presenters,
              file_entries_presenters:  file_entries_presenters,
              current_folder_presenter: current_folder_presenter,
              current_view:             current_view
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
