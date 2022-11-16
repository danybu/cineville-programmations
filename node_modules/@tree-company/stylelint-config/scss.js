const { selectorOrdering } = require("stylelint-semantic-groups");
const propertyOrdering = require("./rules/properties_order");
const { BEMPattern } = require("./rules/selector_class_pattern");

module.exports = {
  extends: ["stylelint-config-standard-scss", "stylelint-prettier/recommended"],
  plugins: ["stylelint-order"],
  rules: {
    "no-invalid-position-at-import-rule": [
      true,
      {
        ignoreAtRules: ["multiple-tailwind"],
      },
    ],
    "selector-class-pattern": BEMPattern,
    "scss/at-rule-no-unknown": [
      true,
      {
        ignoreAtRules: [
          "multiple-tailwind",
          "tailwind",
          "apply",
          "variants",
          "responsive",
          "screen",
          "layer",
        ],
      },
    ],
    "order/order": selectorOrdering,
    "order/properties-order": propertyOrdering,
  },
};
