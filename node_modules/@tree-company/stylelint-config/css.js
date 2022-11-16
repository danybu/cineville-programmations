const { selectorOrdering } = require("stylelint-semantic-groups");
const propertyOrdering = require("./rules/properties_order");
const { BEMPattern } = require("./rules/selector_class_pattern");

module.exports = {
  extends: ["stylelint-config-standard", "stylelint-config-prettier"],
  plugins: ["stylelint-prettier", "stylelint-order"],
  rules: {
    "prettier/prettier": true,
    "selector-class-pattern": BEMPattern,
    "order/order": selectorOrdering,
    "order/properties-order": propertyOrdering,
  },
};
