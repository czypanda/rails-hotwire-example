import js from "@eslint/js";
import globals from "globals";
import json from "@eslint/json";
import markdown from "@eslint/markdown";
import { defineConfig } from "eslint/config";
import eslintPluginPrettierRecommended from "eslint-plugin-prettier/recommended";

export default defineConfig([
  {
    files: ["app/frontend/**/*.{js,mjs,cjs}"],
    plugins: { js },
    extends: [js.configs.recommended, eslintPluginPrettierRecommended],
    languageOptions: { globals: globals.browser },
    rules: {
      eqeqeq: ["error", "always"]
    }
  },
  { files: ["**/*.jsonc"], plugins: { json }, language: "json/jsonc", extends: ["json/recommended"] },
  { files: ["**/*.md"], plugins: { markdown }, language: "markdown/gfm", extends: ["markdown/recommended"] },
]);
