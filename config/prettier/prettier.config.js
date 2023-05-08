module.exports = {
  trailingComma: "es5",
  tabWidth: 2,
  printWidth: 120,
  semi: true,
  singleQuote: false,
  useTabs: false,
  quoteProps: "as-needed",
  jsxSingleQuote: false,
  bracketSameLine: true,
  arrowParens: "avoid",
  requirePragma: false,
  insertPragma: false,
  proseWrap: "preserve",
  endOfLine: "lf",
  overrides: [
    {
      files: ["*.yml", "*.yaml"],
      options: {
        tabWidth: 2,
        bracketSpacing: false,
      },
    },
    {
      files: ["*.json"],
      options: {
        tabWidth: 2,
      },
    },
    {
      files: "*.md",
      options: {
        tabWidth: 1,
      },
    },
  ],
};
