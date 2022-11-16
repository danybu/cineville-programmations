const {
  animations,
  border,
  box,
  clip,
  elementProperties,
  misc,
  scss,
  style,
  typography,
  visuals,
} = require("stylelint-semantic-groups/dist/es5/groups");

const createGroup = (groupName, properties) => ({
  emptyLineBefore: "never",
  noEmptyLineBetween: true,
  groupName,
  properties,
});

const ruleIsArray = (rules) => Array.isArray(rules[0]);

const mergeGroups = (groups) => {
  const groupRules = [];

  for (const [groupName, rules] of Object.entries(groups))
    if (ruleIsArray(rules))
      groupRules.push(...rules.map((props) => createGroup(groupName, props)));
    else groupRules.push(createGroup(groupName, rules));

  return groupRules;
};

module.exports = [
  mergeGroups({
    scss,
    elementProperties,

    box,

    typography,
    border,
    visuals,
    style,

    clip,
    misc,

    animations,
  }),
  { unspecified: "bottomAlphabetical" },
];
