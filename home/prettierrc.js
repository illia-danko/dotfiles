module.exports = {
    trailingComma: "es5",
    tabWidth: 4,
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
            files: ["*.yaml"],
            options: {
                tabWidth: 2,
            },
        },
    ],
};
