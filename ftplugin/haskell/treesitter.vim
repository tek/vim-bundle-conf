if g:use_treesitter

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      ["constructor"] = "Constructor",
      ["pragma"] = "HsString",
      ["module"] = "Type",
      ["keyword"] = "Keyword",
      ["type"] = "HaskellType",
      ["comment"] = "Comment",
      ["class"] = "Class",
      ["parenthesis"] = "DiscreetSymbol",
      ["bracket"] = "DiscreetSymbol",
      ["fun_name"] = "Identifier",
      ["fun_type_name"] = "IdentifierBold",
      ["literal"] = "Constant",
      ["operator"] = "Operator",
      ["type_operator"] = "Operator",
      ["type_parenthesis"] = "Constant",
      ["type_bracket"] = "Constant",
    },
  },
}
EOF

endif
