import { Controller } from '@hotwired/stimulus';
import { ApiController } from './api_controller';

/**
 * @todo use specific controller for dashboard drag and drop and use mixin for core
 * */
export default class DragDropController extends Controller {
  static values = { type: String, id: Number, draggable: Boolean };

  static TARGET_TYPES = {
    folder: 'folder',
    file: 'file'
  };

  connect() {
    this.element.draggable = this.draggableValue;
    this.element.addEventListener('dragstart', this.dragStart.bind(this));
    this.element.addEventListener('dragover', this.dragOver.bind(this));
    this.element.addEventListener('drop', this.drop.bind(this));
  }

  dragStart(event) {
    event.dataTransfer.setData('type', this.typeValue);
    event.dataTransfer.setData('id', this.idValue);
  }

  dragOver(event) {
    event.preventDefault();
  }

  drop(event) {
    event.preventDefault();
    const draggedType = event.dataTransfer.getData('type');
    const draggedId = event.dataTransfer.getData('id');

    const targetId = this.idValue;
    const targetType = this.typeValue;

    if (targetType === DragDropController.TARGET_TYPES.folder) {
      const apiController = new ApiController();

      // Move file or folder into this folder
      if (draggedType === DragDropController.TARGET_TYPES.file) {
        apiController.moveFile({ draggedId, targetId });
      } else if (draggedType === DragDropController.TARGET_TYPES.folder && draggedId !== String(targetId)) {
        apiController.moveFolder({ draggedId, targetId });
      }
    }
  }
}
