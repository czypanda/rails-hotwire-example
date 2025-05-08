import { Application } from '@hotwired/stimulus';
import { registerControllers } from 'stimulus-vite-helpers';

const app = Application.start();

// Configure Stimulus development experience
app.debug = true;
window.Stimulus = app;

const controllers = import.meta.glob('./**/*_controller.js', { eager: true });
registerControllers(app, controllers);
