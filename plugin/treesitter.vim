if g:use_treesitter

lua <<EOF
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.haskell = {
  install_info = {
    url = "~/code/tek/js/tree-sitter-haskell",
    files = {"src/parser.c", "src/scanner.cc"}
  }
}
EOF

lua <<EOF
require "nvim-treesitter.configs".setup {
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false
  }
}
EOF

endif
