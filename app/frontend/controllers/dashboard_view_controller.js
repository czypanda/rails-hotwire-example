import { Controller } from '@hotwired/stimulus';
import { ApiController } from './api_controller';

export default class DashboardViewController extends Controller {
  change(e) {
    const view = e.target.dataset.name;

    const apiController = new ApiController();

    apiController.updateViewPreference({ view });
  }
}
