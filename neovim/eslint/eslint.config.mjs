// Minimal ESLint config for linting JS extracted from HTML <script> tags.
export default [
  {
    files: ["**/*.*"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
    },
    rules: {
      "no-unused-vars": ["warn", { argsIgnorePattern: "^_" }],
      "no-undef": "error",
      "no-debugger": "warn",
      "no-console": "off",
    },
  },
];

