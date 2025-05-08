import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import EnvironmentPlugin from 'vite-plugin-environment'
import FullReload from 'vite-plugin-full-reload'
import StimulusHMR from 'vite-plugin-stimulus-hmr'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
plugins: [
    tailwindcss(),
    RubyPlugin(),
    EnvironmentPlugin(['NODE_ENV']),
    FullReload(['config/routes.rb', 'app/views/**/*']),
    StimulusHMR(),
],
})
