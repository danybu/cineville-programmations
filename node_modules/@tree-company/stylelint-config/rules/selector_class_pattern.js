module.exports = {
  BEMPattern: [
    /^[a-z]+(:)?[a-z]+-?[a-z]*(__[0-9a-z]+-?[0-9a-z]*)?(--[0-9a-z]+-?[a-z]*)?$/,
    {
      resolveNestedSelectors: true,
      message: "Expected class selector to be BEM-style",
    },
  ],
};
