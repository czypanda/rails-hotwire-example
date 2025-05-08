import { Controller } from '@hotwired/stimulus';

export default class UIToastController extends Controller {
  connect() {
    setTimeout(() => {
      this.element.classList.add('hidden');
    }, 3000);
  }
}
