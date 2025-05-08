import { Turbo } from '@hotwired/turbo-rails';

/**
 * @todo move to somewhere else so it is not mixed with other controllers
 * */
export class ApiController {
  #csrfToken() {
    return document.querySelector('meta[name="csrf-token"]').content;
  }

  async visitLinkWithTurboStream(url) {
    return fetch(url, {
      headers: {
        Accept: 'text/vnd.turbo-stream.html'
      }
    })
      .then((r) => r.text())
      .then((html) => Turbo.renderStreamMessage(html));
  }

  async moveFile({ draggedId, targetId }) {
    return fetch(`/file_entries/${draggedId}/move`, {
      method: 'POST',
      headers: {
        Accept: 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml',
        'Content-Type': 'application/json;charset=UTF-8',
        'X-CSRF-Token': this.#csrfToken()
      },
      body: JSON.stringify({ target_file_id: targetId, current_file_id: draggedId })
    })
      .then((r) => r.text())
      .then((html) => Turbo.renderStreamMessage(html));
  }

  async moveFolder({ draggedId, targetId }) {
    return fetch(`/folders/${draggedId}/move`, {
      method: 'POST',
      headers: {
        Accept: 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml',
        'Content-Type': 'application/json;charset=UTF-8',
        'X-CSRF-Token': this.#csrfToken()
      },
      body: JSON.stringify({ target_folder_id: targetId, current_folder_id: draggedId })
    })
      .then((r) => r.text())
      .then((html) => Turbo.renderStreamMessage(html));
  }

  updateViewPreference({ view }) {
    return fetch(`/dashboard/update_view_preference`, {
      method: 'POST',
      headers: {
        Accept: 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml',
        'Content-Type': 'application/json;charset=UTF-8',
        'X-CSRF-Token': this.#csrfToken()
      },
      body: JSON.stringify({ view })
    });
  }
}
