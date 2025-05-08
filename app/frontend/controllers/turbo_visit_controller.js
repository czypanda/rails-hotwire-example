import { Controller } from '@hotwired/stimulus';
import { ApiController } from './api_controller';

export default class TurboVisitController extends Controller {
  static values = {
    url: String
  };

  connect() {
    this.element.classList.add('cursor-pointer');
  }

  visit(event) {
    event.preventDefault();

    const url = this.urlValue || this.element.dataset.url;
    if (!url) return;

    const apiController = new ApiController();

    apiController.visitLinkWithTurboStream(url);
  }
}
