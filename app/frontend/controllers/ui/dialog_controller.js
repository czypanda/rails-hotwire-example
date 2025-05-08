import { Controller } from '@hotwired/stimulus';
import { Turbo } from '@hotwired/turbo-rails';

Turbo.StreamActions['close-modal'] = function () {
  window.dispatchEvent(new Event('close-modal'));
};

export default class UIDialog extends Controller {
  static targets = ['dialog', 'modal', 'focus', 'drag', 'backdrop', 'closeButton'];

  initialize() {
    this.originalParentAction = null;
  }

  handleCloseModal = () => {
    this.closeButtonTarget.click();
  };

  open(e) {
    // dirty hack to prevent the row from being clicked
    if (this.element.closest('tr')) {
      this.originalParentAction = this.element.closest('tr').dataset.action;
      this.element.closest('tr').dataset.action = 'null';
    }

    // Store original position and move to body

    this.openBy(e.target);
    e.preventDefault();

    window.addEventListener('keydown', (e) => this.closeByKey(e), { once: true });
    window.addEventListener('close-modal', this.handleCloseModal, { once: true });
  }

  close(e) {
    this.closeBy(e.target);

    e.preventDefault();
    e.stopImmediatePropagation();

    // Move back to original position

    window.removeEventListener('close-modal', this.handleCloseModal);

    // dirty hack to prevent the row from being clicked
    if (this.element.closest('tr')) {
      this.element.closest('tr').dataset.action = this.originalParentAction;
    }
  }

  toggle(e) {
    if (this.isVisible()) {
      this.closeBy(e.target);
    } else {
      this.openBy(e.target);
    }
    e.preventDefault();
  }

  closeByKey(e) {
    if (e.keyCode === 27) {
      this.closeBy(e.target);
      e.preventDefault();
    }
  }

  isVisible() {
    return this.dialogTarget.classList.contains('st-dialog--visible');
  }

  openBy(target) {
    this.toggleClass(true);

    if (this.hasFocusTarget) {
      this.focusTarget.focus();
    }

    this.dispatch('opened', { detail: { target: target } });
  }

  closeBy(target) {
    this.toggleClass(false);

    if (target.getAttribute('data-ui--dialog-target') === 'modal') {
      document.body.classList.remove('overflow-hidden');
    }
    this.dispatch('closed', { detail: { target: target } });
  }

  toggleClass(visible) {
    if (visible) {
      this.dialogTarget.classList.remove('hidden');
      this.dialogTarget.dataset.state = 'open';
      if (this.hasBackdropTarget) {
        this.backdropTarget.classList.remove('hidden');
        this.backdropTarget.dataset.state = 'open';
      }
      if (this.hasModalTarget) {
        this.modalTarget.classList.remove('hidden');
        this.modalTarget.dataset.state = 'open';
      }
    } else {
      this.dialogTarget.classList.add('hidden');
      this.dialogTarget.dataset.state = 'closed';
      if (this.hasBackdropTarget) {
        this.backdropTarget.classList.add('hidden');
        this.backdropTarget.dataset.state = 'closed';
      }
      if (this.hasModalTarget) {
        this.modalTarget.classList.add('hidden');
        this.modalTarget.dataset.state = 'closed';
      }
    }
  }
}
