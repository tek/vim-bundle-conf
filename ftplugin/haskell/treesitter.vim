if g:use_treesitter

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      ["constructor"] = "Constructor",
      ["pragma"] = "HsString",
      ["module_name"] = "Type",
      ["keyword"] = "Keyword",
      ["type"] = "HaskellType",
      ["comment"] = "Comment",
      ["class"] = "Class",
      ["paren"] = "DiscreetSymbol",
      ["fun_name"] = "Identifier",
      ["fun_type_name"] = "IdentifierBold",
      ["literal"] = "Constant",
    },
  },
}
EOF

endif
